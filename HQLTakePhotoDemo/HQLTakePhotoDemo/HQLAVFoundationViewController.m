//
//  HQLAVFoundationViewController.m
//  HQLTakePhotoDemo
//
//  Created by ToninTech on 2017/2/16.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLAVFoundationViewController.h"
#import <AVFoundation/AVFoundation.h>
#define ThemeColor [UIColor colorWithDisplayP3Red:81/255.0 green:136/255.0 blue:247/255.0 alpha:1.0]

@interface HQLAVFoundationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *openCaptureBtn;
@property (weak, nonatomic) IBOutlet UIButton *canptureBtn;

@property (strong, nonatomic) AVCaptureSession *session;    //媒体管理会话
@property (strong, nonatomic) AVCaptureDeviceInput *captureInput;   //输入数据对象
@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;   //输出数据对象
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureLayer; //视频预览图层


@end

@implementation HQLAVFoundationViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationControllerAppearance];
    
    //初始化摄像头
    [self initCaptureSession];
    
    self.openCaptureBtn.hidden = NO;
    self.canptureBtn.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors
- (void)setNavigationControllerAppearance {
    // 设置导航栏标题&字体&颜色
    self.navigationItem.title = @"AVFoundation拍照";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:ThemeColor}];
}

#pragma mark 初始化摄像头
- (void)initCaptureSession {
    /*
     1️⃣ AVCaptureSession
     媒体捕捉会话，管理输入与输出之间的数据流，以及在出现问题时生成运行时错误。
     负责把捕获到的音频视频数据输出到输出设备上，一个会话可以有多个输入输入。
     */
    // 1.创建媒体管理会话
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    
    self.session = captureSession;
    
    // 判断分辨率是否支持 1280*720，支持就设置为：1280*720
    if ([captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    /*
     2️⃣ AVCaptureDevice
     关于相机硬件的接口。它被用于控制硬件特性，诸如镜头的位置、曝光、闪光灯等。
     */
    
    // 2.获取后置摄像头
    AVCaptureDevice *captureDevice = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            // 获得后置摄像头
            captureDevice = device;
        }
    }
    if (!captureDevice) {
        NSLog(@"2.取得后置摄像头错误！");
        return;
    }
    
    // 取得前置摄像头
    //    AVCaptureDevice *frontCaptureDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    
    /*
     3️⃣ AVCaptureDeviceInput
     设备输入数据管理对象，管理输入数据
     */
    
    // 3.创建输入数据对象
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"3.创建输入数据对象错误");
        return;
    }
    
    self.captureInput = captureInput;
    
    /*
     4️⃣ AVCaptureOutput
     设备输出数据管理对象，管理输出数据，通常使用它的子类：
     AVCaptureAudioDataOutput       //输出音频管理对象，输出数据为NSData
     AVCaptureStillImageDataOutput  //输出图片管理对象，输出数据为NSData
     AVCaptureVideoDataOutput       //输出视频管理对象，输出数据为NSData
     
     AVCaptureFileOutput
     输出文件管理对象，输出数据以文件形式输出
     {//子类
     AVCaptureAudioFileOutput   //输出是音频文件
     AVCaptureMovieFileOutput   //输出是视频文件
     }
     */
    
    // 4.创建输出数据对象
    AVCaptureStillImageOutput *imageOutpot = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *setting = @{
                              AVVideoCodecKey:AVVideoCodecJPEG
                              };
    [imageOutpot setOutputSettings:setting];
    
    self.imageOutput = imageOutpot;
    
    // 5️⃣ 5.添加【输入数据对象】和【输出对象】到会话中
    if ([captureSession canAddInput:captureInput]) {
        [captureSession addInput:captureInput];
    }
    if ([captureSession canAddOutput:imageOutpot]) {
        [captureSession addOutput:imageOutpot];
    }
    
    
    /*
     6️⃣ AVCaptureVideoPreviewLayer
     实时预览图层
     AVCaptureVideoPreviewLayer 是 CALayer 的子类，可被用于自动显示相机产生的实时图像。它还有几个工具性质的方法，可将 layer 上的坐标转化到设备上。它看起来像输出，但其实不是。另外，它拥有 session (outputs 被 session 所拥有)。
     */
    
    // 6.创建实时预览图层
    AVCaptureVideoPreviewLayer *previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    self.view.layer.masksToBounds = YES;
    previewlayer.frame = self.view.bounds;
    previewlayer.videoGravity = AVLayerVideoGravityResizeAspectFill; //设置比例为铺满全屏
    // 【预览图层】插入在【拍照按钮】的下方
    [self.view.layer insertSublayer:previewlayer below:self.canptureBtn.layer];
    
    self.captureLayer = previewlayer;
}

#pragma mark - IBAction

#pragma mark 打开摄像头
- (IBAction)takePhoto:(UIButton *)sender {
    
    self.captureLayer.hidden = NO;
    self.canptureBtn.hidden = NO;
    self.openCaptureBtn.hidden = YES;
    
    
    // 判断相机使用权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            NSLog(@"相机权限获取失败！");
            break;
        case AVAuthorizationStatusAuthorized:
            [self.session startRunning]; //开始捕捉
            break;
        case AVAuthorizationStatusNotDetermined: {
            // 还未决定，发起请求获取相机权限提示
            [AVCaptureDevice
             requestAccessForMediaType:AVMediaTypeVideo
             completionHandler:^(BOOL granted) {
                 if (granted) {
                     [self.session startRunning]; //开始捕捉
                 } else {
                     NSLog(@"相机权限获取失败！");;
                 }
             }];
            break;
        }
    }
}

#pragma mark 拍照

- (IBAction)takeMedia:(id)sender {
    // 根据设备输出获得连接
    AVCaptureConnection *connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    // 通过连接获得设备的输出数据
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        // 获取输出的JPG图片
        NSData *imgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [UIImage imageWithData:imgData];
        
        self.imageView.image = image;
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);   //保存到相册
        self.captureLayer.hidden = YES;
        self.canptureBtn.hidden = YES;
        self.openCaptureBtn.hidden = NO;
        [self.session stopRunning];
    }];
}

#pragma mark - 将摄像头在前置/后置之间切换

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

@end
