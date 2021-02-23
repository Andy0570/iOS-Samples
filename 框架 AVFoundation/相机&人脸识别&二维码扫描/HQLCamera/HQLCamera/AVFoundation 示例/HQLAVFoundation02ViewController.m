//
//  HQLAVFoundation02ViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLAVFoundation02ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <JKCategories.h>

@interface HQLAVFoundation02ViewController () <AVCaptureFileOutputRecordingDelegate>

@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *openCameraButton;

@property (strong, nonatomic) AVCaptureSession *session;                // 媒体管理会话
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;        // 输入数据对象
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;    // 视频输出对象
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer; // 视频预览图层

@end

@implementation HQLAVFoundation02ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithCaptureSession];
    
    self.captureButton.hidden = YES;
    self.openCameraButton.hidden = NO;
}

#pragma mark - Private

// 初始化摄像头
- (void)initWithCaptureSession {
    // 1.创建媒体管理会话
    self.session = [[AVCaptureSession alloc] init];
    // 判断拍摄分辨率是否支持 1280*720，支持就设置为 1280*720
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    // 2.1 获取后置摄像头
    AVCaptureDevice *captureDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) {
        [self.view jk_makeToast:@"无法获取后置摄像头！"];
        return;
    }
    
    // 2.2 获取麦克风设备对象
    AVCaptureDeviceDiscoverySession *microphoneDevice = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInMicrophone] mediaType:AVMediaTypeAudio position:AVCaptureDevicePositionUnspecified];
    AVCaptureDevice *audioDevice = microphoneDevice.devices.firstObject;
    if (!audioDevice) {
        [self.view jk_makeToast:@"无法获取麦克风设备！"];
        return;
    }
    
    // 3.1 创建摄像头输入数据对象
    NSError *error = nil;
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        [self.view jk_makeToast:@"创建视频输入数据对象错误！"];
        return;
    }
    // 将「摄像头输入数据对象」添加到会话中
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
    
    // 3.2 创建麦克风输入数据对象
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (error) {
        [self.view jk_makeToast:@"创建麦克风输入数据对象错误！"];
        return;
    }
    // 将「麦克风输入数据对象」添加到会话中
    if ([self.session canAddInput:audioInput]) {
        [self.session addInput:audioInput];
    }
    
    // 4.创建视频文件输出对象
    self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    // 将「输出数据对象」添加到会话中
    if ([self.session canAddOutput:self.movieOutput]) {
        [self.session addOutput:self.movieOutput];
        
        // MARK: 添加防抖功能，自动
        AVCaptureConnection *connection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    // 5.创建视频预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.view.layer.masksToBounds = YES;
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 将「实时预览图层」添加到「拍摄按钮的下方」
    [self.view.layer insertSublayer:self.previewLayer below:self.captureButton.layer];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    // 通过广角摄像头拍摄视频
    AVCaptureDeviceDiscoverySession *deviceIOS10 = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    
    for (AVCaptureDevice *device in deviceIOS10.devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark - Actions

// 打开摄像头
- (IBAction)openCameraButtonAction:(id)sender {
    self.previewLayer.hidden = NO;
    self.captureButton.hidden = NO;
    self.openCameraButton.hidden = YES;
    
    // MARK: 判断相机使用权限
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authorizationStatus) {
            case AVAuthorizationStatusAuthorized:
                [self.session startRunning]; //开始捕捉
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                [self.view jk_makeToast:@"请打开相机权限～"];
                break;
            case AVAuthorizationStatusNotDetermined:
                // 用户还没有决定是否打开相机，立即发出相机调用请求
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        [self.session startRunning]; //开始捕捉
                    } else {
                        [self.view jk_makeToast:@"没有相机权限～"];
                    }
                }];
                break;
        }
    }
}

// 开始录像
- (IBAction)captureButtonAction:(id)sender {
    if (!self.movieOutput.isRecording) {
        [self.captureButton setTitle:@"停止录制" forState:UIControlStateNormal];
        
        // 临时文件夹路径
        NSString *movieName = [NSString stringWithFormat:@"%@.mov",NSString.jk_UUID];
        NSString *outputPath = [NSTemporaryDirectory() stringByAppendingString:movieName];
        NSURL *url = [NSURL fileURLWithPath:outputPath];
        
        // 开始录制并设置代理监控录制过程，录制文件会存放到指定URL路径下
        [self.movieOutput startRecordingToOutputFileURL:url recordingDelegate:self];
    } else {
        // 停止录制
        [self.movieOutput stopRecording];
        [self.captureButton setTitle:@"开始录制" forState:UIControlStateNormal];
    }
}

#pragma mark - <AVCaptureFileOutputRecordingDelegate>

// 开始录制会调用
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"开始录制");
}

// ...

// 录制完成后调用
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(nullable NSError *)error
{
    NSLog(@"录制完成");
    
    NSString *path = outputFileURL.path;
    // 保存录制视频到相册
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
        UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil);
    }
    
    // 停止运行会话
    [self.session stopRunning];
    self.previewLayer.hidden = YES;
}

@end
