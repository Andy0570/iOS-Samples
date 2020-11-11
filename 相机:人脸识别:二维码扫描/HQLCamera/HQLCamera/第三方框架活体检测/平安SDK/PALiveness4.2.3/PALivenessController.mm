//
//  PALivenessController.m
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/3/27.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "PALivenessController.h"

#import <YYKit.h>

#import <AVFoundation/AVFoundation.h>
#import "PANumberLabel.h"
#import "PAImage.h"

#define KPAViewTagBase 1000

@interface PALivenessController () <PALivenessProtocolDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
    NSArray *_detectionArr;
    NSInteger _detectionIndex;
}

@property (strong, nonatomic) UIImageView *imageMaskView;
@property (strong, nonatomic) UIImage *imageMask;
@property (strong, nonatomic) UIView *blackMaskView;

@property (strong, nonatomic) UIImageView *imageAnimationView;
@property (strong, nonatomic) UIImageView *imageAnimationBGView;

@property (strong, nonatomic) UIView *stepBackGroundView;
@property (strong, nonatomic) UIView *stepBGViewBGView;

@property (strong, nonatomic) UILabel *trackerPromptLabel; // 初始化提示文字标签
@property (strong, nonatomic) UILabel *promptLabel; // 具体步骤提示文字标签
@property (strong, nonatomic) UILabel *countDownLable;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *soundButton;
@property (strong, nonatomic) UIButton *cameraReverseButton;

@property (strong, nonatomic) UIImage *imageSoundOn;
@property (strong, nonatomic) UIImage *imageSoundOff;

// 提示音频
@property (strong, nonatomic) AVAudioPlayer *mouthAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *yawAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *currentAudioPlayer;
@property (assign, nonatomic) CGFloat currentPlayerVolume; // 当前播放器音量，0.8或者0

// 提示图片数组
@property (strong, nonatomic) NSArray *arrMouthImages;
@property (strong, nonatomic) NSArray *arrYawImages;

@property (strong, nonatomic) AVCaptureSession *session;            // 媒体管理会话
@property (strong, nonatomic) AVCaptureDevice *deviceFront;         // 相机硬件接口
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;    // 输入数据对象
@property (strong, nonatomic) AVCaptureVideoDataOutput *dataOutput; // 输出数据对象
@property (assign, nonatomic) CGRect previewframe;                  // 预览图层frame

@property (copy, nonatomic) NSString *bundlePathStr;

@property (weak, nonatomic) id<PALivenessDetectorDelegate> controllerDelegate;
@property (assign, nonatomic) PALivenessDetectionType LivenessDetectionType;

@property (assign, nonatomic) BOOL isShowCountDownView;
@property (assign, nonatomic) BOOL is3_5InchScreen;
@property (assign, nonatomic) BOOL isCameraPermission;

@property (strong, nonatomic) NSOperationQueue *mainQueue;
@property (strong, nonatomic) dispatch_queue_t dispatchQueue;

@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic, assign) CFAbsoluteTime lastUpdateTime;

@end

@implementation PALivenessController

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Method Undefined"
                                   reason:@"Use Designated Initializer Method"
                                 userInfo:nil];
    return nil;
}

// 指定初始化方法
- (instancetype)initWithSetDelegate:(id<PALivenessDetectorDelegate>)delegate
              livenessDetectionType:(PALivenessDetectionType)detectionType
{
    self = [super init];
    if (self) {
        if (!detectionType) {
            NSLog(@" ╔———————————— WARNING ————————————╗");
            NSLog(@" |                                 |");
            NSLog(@" |  Please set detection sequence !|");
            NSLog(@" |                                 |");
            NSLog(@" ╚—————————————————————————————————╝");
        }else {
            // 初始化活体检测对象
            _LivenessDetectionType = detectionType;
            _detector = [PALivenessDetector detectorOfWithDetectionType:detectionType delegate:self];
            _detectionArr = @[@"1"]; // 动作数目
            _detectionIndex = 0;     // 当前动作索引
            
            // 加载资源路径
            _bundlePathStr = [[NSBundle mainBundle] pathForResource:@"st_liveness_resource" ofType:@"bundle"];
            
            // 相机预览图层frame
            _previewframe = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            
            _isVoicePrompt = YES; // 默认开启语音
            
            _currentPlayerVolume = 0.8; // 默认播放器音量
            
            _imageSoundOn = [self imageWithFullFileName:@"st_sound_on.png"];
            _imageSoundOff = [self imageWithFullFileName:@"st_sound_off.png"];
            
            if (_controllerDelegate != delegate) {
                _controllerDelegate = delegate;
            }
            
            _mainQueue = [NSOperationQueue mainQueue];
            
            // 创建自定义串行队列，用于序列化传入录制的图像桢进行活体检测比对
            self.dispatchQueue = dispatch_queue_create("gov.jsxzlss.XuZhouSS.PALivenessDetector", DISPATCH_QUEUE_SERIAL);
        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.is3_5InchScreen = (kScreenHeight == 480);
    
    [self setupUI]; // 初始化视图
    
    [self displayViewsIfRunning:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if !TARGET_IPHONE_SIMULATOR
    
    BOOL bSetupCaptureSession = [self setupCaptureSession]; // 初始化媒体管理会话
    if (!bSetupCaptureSession) {
        return;
    }
    
    [self setupAudio]; // 初始化音频文件
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self cameraStart]; // 判断相机使用权限
    
    if (self.detector && self.session && self.dataOutput && ![self.session isRunning]) {
        [self.session startRunning]; // 开始捕捉视频
    }
}

- (void)dealloc {
    if (_session) {
        [_session beginConfiguration];
        [_session removeOutput:_dataOutput];
        [_session removeInput:_deviceInput];
        [_session commitConfiguration];
        
        if ([_session isRunning]) {
            [_session stopRunning];
        }
    }
    
    if ([_currentAudioPlayer isPlaying]) {
        [_currentAudioPlayer stop];
    }
    
    if ([_imageAnimationView isAnimating]) {
        [_imageAnimationView stopAnimating];
    }
    
    self.controllerDelegate = nil;
}

#pragma mark - Custom Accessors

// 设置是否语音提示
- (void)setIsVoicePrompt:(BOOL)isVoicePrompt {
    _isVoicePrompt = isVoicePrompt;
    [self setPlayerVolume];
}

#pragma mark - IBActions

// 返回按钮
- (void)onbackButton {
    
    [self clearStepViewAndStopSoundInvalidateTimer];
    [self displayViewsIfRunning:NO];
    
    // 取消检测
    if (self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(livenessDidCancel)]) {
        [self.mainQueue addOperationWithBlock:^{
            
            // 关闭视图并回调代理方法
            [self dismissViewControllerAnimated:YES completion:^{
                [self.controllerDelegate livenessDidCancel];
            }];
        }];
    }
}

// 语音按钮
- (void)onsoundButton {
    self.isVoicePrompt = !self.isVoicePrompt;
    
    [self setPlayerVolume];
}

// 切换相机前置/后置
- (void)onCameraReverseButton {
    NSLog(@"camera button did clicked!!!");
    
    // ------1. 切换摄像头
    [self swapFrontAndBackCameras];
    
    // ------2.重置检测类型
    [self.detector resetWithDetectionType:DETECTION_TYPE_MouthOpen];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            return device;
        }
    }
    return nil;
}

- (void)swapFrontAndBackCameras {
    // Assume the session is already running
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            // beginConfiguration ensures that pending changes are not applied immediately
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}

#pragma mark - Private

/**
 初始化UI，修改界面布局，图片元素，提示文字
 */
- (void)setupUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    // ------遮罩图片，small：640*960，big：750*1334
    self.imageMask = [self imageWithFullFileName:self.is3_5InchScreen ? @"st_mask_s.png" : @"st_mask_b.png"];
    
    // ------遮罩图层
    self.imageMaskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.imageMaskView.image = self.imageMask;
    self.imageMaskView.userInteractionEnabled = YES;
    self.imageMaskView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageMaskView];
    
    // ------初始化UI时的黑色半透明遮罩层
    self.blackMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.blackMaskView.backgroundColor = [UIColor blackColor];
    self.blackMaskView.alpha = 0.3;
    [self.imageMaskView addSubview:self.blackMaskView];
    
    // ------张嘴图片
    UIImage *imageMouth1 = [self imageWithFullFileName:@"st_mouth1.png"];
    UIImage *imageMouth2 = [self imageWithFullFileName:@"st_mouth2.png"];
    
    // ------左右摇头图片
    UIImage *imageYaw1 = [self imageWithFullFileName:@"st_yaw1.png"];
    UIImage *imageYaw2 = [self imageWithFullFileName:@"st_yaw2.png"];
    UIImage *imageYaw3 = [self imageWithFullFileName:@"st_yaw3.png"];
    UIImage *imageYaw4 = [self imageWithFullFileName:@"st_yaw4.png"];
    UIImage *imageYaw5 = [self imageWithFullFileName:@"st_yaw5.png"];
    
    if (imageMouth1 && imageMouth2) {
        self.arrMouthImages = @[imageMouth1, imageMouth2];
    }
    
    if (imageYaw1 && imageYaw2 && imageYaw3 && imageYaw4 && imageYaw5) {
        self.arrYawImages = @[imageYaw1, imageYaw2, imageYaw3, imageYaw4, imageYaw5, imageYaw4, imageYaw3, imageYaw2];
    }
    
    // ------1234 文本标签容器
    self.stepBackGroundView =
    [[UIView alloc] initWithFrame:self.is3_5InchScreen ?
     CGRectMake(0, 0, _detectionArr.count * 16.0 + (_detectionArr.count - 1) * 8.0, 16.0) :
     CGRectMake(0, 0, _detectionArr.count * 20.0 + (_detectionArr.count - 1) * 10.0, 20.0)];
    self.stepBackGroundView.backgroundColor = [UIColor clearColor];
    self.stepBackGroundView.hidden = YES;
    self.stepBackGroundView.centerX = kScreenWidth / 2.0;
    self.stepBackGroundView.bottom = self.imageMaskView.bottom - 20;
    self.stepBackGroundView.userInteractionEnabled = NO;
    
    // ------1234 后面的黑色背景
    self.stepBGViewBGView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.stepBackGroundView.frame.size.width + 6.0,
                                                                     self.stepBackGroundView.frame.size.height + 6.0)];
    self.stepBGViewBGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.stepBGViewBGView.layer.cornerRadius = self.stepBGViewBGView.frame.size.height / 2.0;
    self.stepBGViewBGView.center = self.stepBackGroundView.center;
    self.stepBGViewBGView.hidden = YES;
    [self.imageMaskView addSubview:self.stepBGViewBGView];
    [self.imageMaskView addSubview:self.stepBackGroundView];
    
    // ------1234 标签
    for (int i = 0; i < _detectionArr.count; i++) {
        PANumberLabel *lblStepNumber =
        [[PANumberLabel alloc] initWithFrame:self.is3_5InchScreen ? CGRectMake(i * 20.0 + i * 4.0, 0, 16.0, 16.0) :
         CGRectMake(i * 25.0 + i * 5.0, 0, 20.0, 20.0)
                                      number:i + 1];
        lblStepNumber.tag = i + KPAViewTagBase;
        [self.stepBackGroundView addSubview:lblStepNumber];
    }
    
    // ------动画视图背景
    self.imageAnimationBGView =
    [[UIImageView alloc] initWithFrame:self.is3_5InchScreen ? CGRectMake(0, 0, kScreenWidth, 130.0) :
     CGRectMake(0, 0, kScreenWidth, 150.0)];
    self.imageAnimationBGView.bottom = self.stepBGViewBGView.top - 16.0;
    [self.imageMaskView addSubview:self.imageAnimationBGView];
    
    CGFloat fAnimationViewWidth = self.is3_5InchScreen ? 80.0 : 100.0;
    
    // ------动画视图
    self.imageAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - fAnimationViewWidth) / 2,
                                                                            0,
                                                                            fAnimationViewWidth,
                                                                            fAnimationViewWidth)];
    self.imageAnimationView.top = self.imageAnimationBGView.height - self.imageAnimationView.height + 10;
    self.imageAnimationView.animationDuration = 2.0f;
    self.imageAnimationView.layer.cornerRadius = self.imageAnimationView.frame.size.width / 2; //圆角
    self.imageAnimationView.backgroundColor = [UIColor colorWithHexString:@"0xC8C8C8"];
    [self.imageAnimationBGView addSubview:self.imageAnimationView];
    
    // ------倒计时
    float fLabelCountDownWidth = self.is3_5InchScreen ? 36.0 : 45.0;
    self.countDownLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fLabelCountDownWidth, fLabelCountDownWidth)];
    self.countDownLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.countDownLable.textColor = [UIColor whiteColor];
    self.countDownLable.right = self.imageMaskView.width * 0.85;
    self.countDownLable.centerY = self.imageAnimationView.centerY + self.imageAnimationBGView.top;
    self.countDownLable.layer.cornerRadius = fLabelCountDownWidth / 2.0f;
    self.countDownLable.clipsToBounds = YES;
    self.countDownLable.adjustsFontSizeToFitWidth = YES;
    self.countDownLable.font = [UIFont systemFontOfSize:fLabelCountDownWidth / 2.0f];
    self.countDownLable.textAlignment = NSTextAlignmentCenter;
    self.countDownLable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.imageMaskView addSubview:self.countDownLable];
    
    // ------提示文字
    self.promptLabel =
    [[UILabel alloc] initWithFrame:self.is3_5InchScreen ? CGRectMake(0, 0, 90, 30.0) : CGRectMake(0, 0, 90, 38.0)];
    self.promptLabel.center = CGPointMake(self.imageAnimationView.centerX, self.imageAnimationView.top - 14.0 - 10);
    self.promptLabel.font = [UIFont systemFontOfSize:self.is3_5InchScreen ? 15.0 : 20];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.layer.cornerRadius = self.promptLabel.height / 2.0;
    self.promptLabel.layer.masksToBounds = YES;
    self.promptLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.imageAnimationBGView addSubview:self.promptLabel];
    
    // ------tracker提示文字
    self.trackerPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38.0)];
    self.trackerPromptLabel.center = CGPointMake(self.imageAnimationView.centerX, self.imageAnimationView.top);
    self.trackerPromptLabel.font = [UIFont systemFontOfSize:self.is3_5InchScreen ? 15.0 : 20.0];
    self.trackerPromptLabel.textAlignment = NSTextAlignmentCenter;
    self.trackerPromptLabel.textColor = [UIColor whiteColor];
    self.trackerPromptLabel.text = @"请正对手机";
    [self.imageAnimationBGView addSubview:self.trackerPromptLabel];
    
    // ------语音按钮
    UIButton *soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [soundButton setFrame:self.is3_5InchScreen ? CGRectMake(kScreenWidth - 50, 30, 30, 30) :
     CGRectMake(kScreenWidth - 58, 30, 38, 38)];
    [soundButton setImage:self.isVoicePrompt ? self.imageSoundOn : self.imageSoundOff forState:UIControlStateNormal];
    [soundButton addTarget:self action:@selector(onsoundButton) forControlEvents:UIControlEventTouchUpInside];
    [self.imageMaskView addSubview:soundButton];
    self.soundButton = soundButton;
    
    // ------返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setFrame:self.is3_5InchScreen ? CGRectMake(20, 30, 30, 30) : CGRectMake(20, 30, 38, 38)];
    [backButton setImage:[self imageWithFullFileName:@"st_scan_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onbackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.imageMaskView addSubview:backButton];
    self.backButton = backButton;
    
    // ------切换相机前置/后置摄像头按钮
    UIButton *reverseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reverseButton setFrame:self.is3_5InchScreen ? CGRectMake(0, 0, 64, 64) : CGRectMake(0, 0, 64, 64)];
    reverseButton.bottom = self.imageMaskView.bottom - 20;
    reverseButton.right = self.soundButton.right;
    [reverseButton setImage:[self imageWithFullFileName:@"camera_reverse"] forState:UIControlStateNormal];
    [reverseButton addTarget:self action:@selector(onCameraReverseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.imageMaskView addSubview:reverseButton];
    self.cameraReverseButton = reverseButton;
}


/**
 初始化音频文件
 */
- (void)setupAudio {
    // 张嘴音频
    NSString *mouthPathStr = [self audioPathWithFullFileName:@"st_notice_mouth.mp3"];
    self.mouthAudioPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:mouthPathStr] error:nil];
    self.mouthAudioPlayer.volume = self.currentPlayerVolume;
    self.mouthAudioPlayer.numberOfLoops = -1;
    [self.mouthAudioPlayer prepareToPlay];
    
    // 左右摇头音频
    NSString *yawPathStr = [self audioPathWithFullFileName:@"st_notice_yaw.mp3"];
    self.yawAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:yawPathStr] error:nil];
    self.yawAudioPlayer.volume = self.currentPlayerVolume;
    self.yawAudioPlayer.numberOfLoops = -1;
    [self.yawAudioPlayer prepareToPlay];
}


/**
 初始化摄像
 */
- (BOOL)setupCaptureSession {
#if !TARGET_IPHONE_SIMULATOR
    
    self.session = [[AVCaptureSession alloc] init];
    // iPhone 4S, +
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer =
    [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    captureVideoPreviewLayer.frame = self.previewframe;
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    [self.view bringSubviewToFront:self.blackMaskView];
    [self.view bringSubviewToFront:self.imageMaskView];
    
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo] && [device position] == AVCaptureDevicePositionBack) {
            self.deviceFront = device;
        }
    }
    
    int frameRate;
    CMTime frameDuration = kCMTimeInvalid;
    
    frameRate = 30;
    frameDuration = CMTimeMake(1, frameRate);
    
    NSError *error = nil;
    if ([self.deviceFront lockForConfiguration:&error]) {
        self.deviceFront.activeVideoMaxFrameDuration = frameDuration;
        self.deviceFront.activeVideoMinFrameDuration = frameDuration;
        [self.deviceFront unlockForConfiguration];
    }
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.deviceFront error:&error];
    self.deviceInput = input;
    
    self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.dataOutput setAlwaysDiscardsLateVideoFrames:YES];
    //视频的格式只能为kCVPixelFormatType_32BGRA
    [self.dataOutput
     setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                  forKey:(id) kCVPixelBufferPixelFormatTypeKey]];
    dispatch_queue_t queueBuffer = dispatch_queue_create("LIVENESS_BUFFER_QUEUE", NULL);
    [self.dataOutput setSampleBufferDelegate:self queue:queueBuffer];
    
    [self.session beginConfiguration];
    
    if ([self.session canAddOutput:self.dataOutput]) {
        [self.session addOutput:self.dataOutput];
    }
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    [self.session commitConfiguration];
#endif
    
    return YES;
}

- (void)cameraStart {
    // 判断相机使用权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice
             requestAccessForMediaType:AVMediaTypeVideo
             completionHandler:^(BOOL granted) {
                 if (granted) {
                     self.isCameraPermission = YES;
                 } else {
                     [self cameraAuthorizationStatusDeniedAndDismissViewController];
                 }
             }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            self.isCameraPermission = YES;
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            [self cameraAuthorizationStatusDeniedAndDismissViewController];
            break;
        }
    }
}

-(void)cameraAuthorizationStatusDeniedAndDismissViewController {
    
    if (self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(livenessDidFailWithErrorType:)]) {
            [self.mainQueue addOperationWithBlock:^{
                
                // 关闭视图并回调代理方法
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.controllerDelegate livenessDidFailWithErrorType:PALivenessControllerDetectionFailureTypeCameraDenied];
                }];
                }];
        }
}

// 根据检测类型，更新UI和提示音频
- (void)showPromptWithDetectionType:(DetectMotionType)motionType detectionIndex:(NSInteger)index {

    PANumberLabel *lblNumber = [self.stepBackGroundView viewWithTag:KPAViewTagBase + index];
    lblNumber.isHighlight = YES;
    
    if ([self.imageAnimationView isAnimating]) {
        [self.imageAnimationView stopAnimating];
    }
    
    if (self.currentAudioPlayer) {
        [self stopAudioPlayer];
    }
    
    CATransition *transion = [CATransition animation];
    transion.type = @"push";
    transion.subtype = @"fromRight";
    transion.duration = 0.5f;
    transion.removedOnCompletion = YES;
    [self.imageAnimationBGView.layer addAnimation:transion forKey:nil];
    
    switch (motionType) {
        case DETECTION_TYPE_YAW: {
            self.promptLabel.text = @"请缓慢摇头";
            self.promptLabel.width = 140;
            self.promptLabel.left = (kScreenWidth - self.promptLabel.width) / 2.0;
            self.imageAnimationView.animationDuration = 2.0f;
            self.imageAnimationView.animationImages = self.arrYawImages;
            self.currentAudioPlayer = self.yawAudioPlayer;
            break;
        }
            
        case DETECTION_TYPE_MouthOpen: {
            self.promptLabel.text = @"请张嘴，随后合拢";
            self.promptLabel.width = 200;
            self.promptLabel.left = (kScreenWidth - self.promptLabel.width) / 2.0;
            self.imageAnimationView.animationDuration = 1.0f;
            self.imageAnimationView.animationImages = self.arrMouthImages;
            self.currentAudioPlayer = self.mouthAudioPlayer;
            break;
        }
        default: {
            return;
            break;
        }
    }
    
    if (![self.imageAnimationView isAnimating]) {
        [self.imageAnimationView startAnimating];
    }
    
    if (self.currentAudioPlayer) {
        [self stopAudioPlayer];
        [self.currentAudioPlayer play];
    }
}

- (void)displayViewsIfRunning:(BOOL)bRunning {
    self.blackMaskView.hidden = bRunning;
    self.imageAnimationView.hidden = !bRunning;
    self.promptLabel.hidden = !bRunning;
    self.stepBackGroundView.hidden = !bRunning;
    self.stepBGViewBGView.hidden = !bRunning;
    self.countDownLable.hidden = self.isShowCountDownView ? !bRunning : YES;
    self.trackerPromptLabel.hidden = bRunning;
    self.trackerPromptLabel.text = @"";
}

- (void)clearStepViewAndStopSoundInvalidateTimer {
    if (self.currentAudioPlayer) {
        [self stopAudioPlayer];
    }
    for (PANumberLabel *lblNumber in self.stepBackGroundView.subviews) {
        lblNumber.isHighlight = NO;
    }
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
}

- (void)stopAudioPlayer {
    if ([self.currentAudioPlayer isPlaying]) {
        self.currentAudioPlayer.currentTime = 0;
        [self.currentAudioPlayer stop];
    }
}

// 设置语音是否开启？开启，音量0.8，不开启，音量0.
- (void)setPlayerVolume {
    [self.soundButton setImage:self.isVoicePrompt ? self.imageSoundOn : self.imageSoundOff
                      forState:UIControlStateNormal];
    
    // 设置声音音量
    self.currentPlayerVolume = self.isVoicePrompt ? 0.8 : 0;
    
    self.mouthAudioPlayer.volume = self.currentPlayerVolume;
    self.yawAudioPlayer.volume = self.currentPlayerVolume;
}

- (UIImage *)imageWithFullFileName:(NSString *)fileNameStr {
    NSString *filePathStr = [NSString pathWithComponents:@[self.bundlePathStr, @"images", fileNameStr]];
    return [UIImage imageWithContentsOfFile:filePathStr];
}

- (NSString *)audioPathWithFullFileName:(NSString *)fileNameStr {
    NSString *filePathStr = [NSString pathWithComponents:@[self.bundlePathStr, @"sounds", fileNameStr]];
    return filePathStr;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    if (self.isCameraPermission && self.detector) {
        // 把 sampleBuffer 转化为图片，同时修正图片方向
        UIImage *faceImage = PAFixOrientationFromSampleBuffer(sampleBuffer, UIImageOrientationRight);
        if (faceImage) {
            dispatch_async(self.dispatchQueue, ^{
                // 对连续输入帧进行人脸跟踪及活体检测
                [self.detector detectWithImage:faceImage];
            });
        }
    }
}

#pragma mark - PALivenessProtocolDelegate

// 用户行为的建议
-(void)onDetectTips:(DetectErrorEnum)detectTip {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch (detectTip) {
            case ENVIORNMENT_ERROR_TOOCLSE:
                self.trackerPromptLabel.text = @"请移动手机远离面部";
                break;
            case ENVIORNMENT_ERROR_TOOFAR:
                self.trackerPromptLabel.text = @"请移动手机靠近面部";
                break;
            case ENVIORNMENT_ERROR_TOOBRIGHT:
                self.trackerPromptLabel.text = @"环境光线太强";
                break;
            case ENVIORNMENT_ERROR_TOODARK:
                self.trackerPromptLabel.text = @"环境光线太暗";
                break;
            case ENVIORNMENT_ERROR_TOOPARTIAL:
                self.trackerPromptLabel.text = @"请将人脸移入框内";
                break;
            case ENVIORNMENT_ERROR_NOFACE:
                self.trackerPromptLabel.text = @"请将人脸移入框内";
                break;
            case ENVIORNMENT_ERROR_FUZZY:
                self.trackerPromptLabel.text = @"人脸过于模糊";
                break;
            case ENVIORNMENT_ERROR_MOVEMENT:
                self.trackerPromptLabel.text = @"请保持相对静止";
                break;
            case ENVIORNMENT_ERROR_MULTIFACE:
                self.trackerPromptLabel.text = @"采集框存在多人";
                break;
            case ENVIORNMENT_ERROR_NORMAL:
                self.trackerPromptLabel.text = @"准备开始检测";
                // 更新采集框颜色为绿色
                self.imageMaskView.image = [self imageWithFullFileName:self.is3_5InchScreen ? @"st_mask_green_s.png" : @"st_mask_green_b.png"];
                break;
        }
    });
}

// 活体检测动作回调，当前活体检测更换动作时调用
-(void)onDetectMotionTips:(DetectMotionType)motionType {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayViewsIfRunning:YES];
        
        // 根据返回的活体检测类型，更新图片动画和提示音频
        [self showPromptWithDetectionType:motionType detectionIndex:self->_detectionIndex];
    });
}

// 动作检测成功
- (void)onDetectionSuccess:(PALivenessDetectionFrame *)faceInfo {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearStepViewAndStopSoundInvalidateTimer];
        [self displayViewsIfRunning:NO];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(livenessDidSuccessfulWithFaceImage:faceImageInfo:)]) {
        [self.mainQueue addOperationWithBlock:^{
            
            // 人脸图片信息
            PAFaceAttr attr = faceInfo.attr; // 结构体
            NSValue *faceAttr = [NSValue value:&attr withObjCType:@encode(struct PAFaceAttr)];
            NSDictionary *faceImageInfo = @{
                                            @"face_image_info_struct":faceAttr
                                            };
            
            // 截取图片
            UIImage *croppedFaceImage = PACroppedImage(faceInfo.image, attr.face_rect);
            
            // 关闭视图并回调代理方法
            [self dismissViewControllerAnimated:YES completion:^{
                [self.controllerDelegate livenessDidSuccessfulWithFaceImage:croppedFaceImage
                                                              faceImageInfo:faceImageInfo];
            }];
        }];
    }
}

// 错误类型回调
-(void)onDetectFailed:(DetectionFailedType)failedType {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearStepViewAndStopSoundInvalidateTimer];
        [self displayViewsIfRunning:NO];
    });
    
    if (self.controllerDelegate && [self.controllerDelegate respondsToSelector:@selector(livenessDidFailWithErrorType:)]) {
        [self.mainQueue addOperationWithBlock:^{
            
            // 关闭视图并回调代理方法
            [self dismissViewControllerAnimated:YES completion:^{
                switch (failedType) {
                    case DETECTION_FAILED_TYPE_ACTIONBLEND: //动作错误
                        [self.controllerDelegate livenessDidFailWithErrorType:PALivenessControllerDetectionFailureTypeActionBlend];
                        break;
                    case DETECTION_FAILED_TYPE_DiscontinuityAttack: //非连续性攻击
                        [self.controllerDelegate livenessDidFailWithErrorType:PALivenessControllerDetectionFailureTypeDiscontinuityAttack];
                        break;
                }
            }];
            
        }];
    }
}

@end
