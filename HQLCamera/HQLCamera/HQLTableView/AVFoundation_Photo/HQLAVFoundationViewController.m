//
//  HQLAVFoundationViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLAVFoundationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <JKCategories.h>

#define ThemeColor [UIColor colorWithDisplayP3Red:81/255.0 green:136/255.0 blue:247/255.0 alpha:1.0]

@interface HQLAVFoundationViewController () <AVCapturePhotoCaptureDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *openCaptureButton;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@property (strong, nonatomic) AVCaptureSession *session;                // 媒体管理会话
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;        // 输入数据对象
@property (strong, nonatomic) AVCapturePhotoOutput *photoOutput;        // 输出数据对象
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer; // 视频预览图层


@end

@implementation HQLAVFoundationViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationControllerAppearance];
    
    //初始化摄像头
    [self initCaptureSession];
    
    self.openCaptureButton.hidden = NO;
    self.captureButton.hidden = YES;
}

- (void)setNavigationControllerAppearance {
    // 设置导航栏标题&字体&颜色
    self.navigationItem.title = @"AVFoundation";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:ThemeColor}];
}

#pragma mark 初始化摄像头
- (void)initCaptureSession {
    /**
     MARK: 1.创建媒体管理会话
     
     AVCaptureSession 是媒体捕捉会话，管理输入与输出之间的数据流，以及在出现问题时生成运行时错误。
     负责把捕获到的音频视频数据输出到输出设备上，一个会话可以有多个输入输入。
     */
    self.session = [[AVCaptureSession alloc] init];
    
    // 判断分辨率是否支持 1280*720，支持就设置为：1280*720
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    
    /**
     MARK: 2. 获取后置摄像头
     
     AVCaptureDevice 是关于相机硬件的接口。它被用于控制硬件特性，诸如镜头的位置、曝光、闪光灯等。
     */
    AVCaptureDevice *captureDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    
    
    /**
     MARK: 3. 创建输入数据对象
     
     AVCaptureDeviceInput 设备输入数据管理对象，管理输入数据
     */
    NSError *error = nil;
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"3.创建输入数据对象错误");
        return;
    }
    // 添加【输入数据对象】到会话中
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }
    
    
    /**
     MARK: 4.创建输出数据对象
     
     AVCaptureOutput 设备输出数据管理对象，管理输出数据，通常使用它的子类：
     AVCaptureAudioDataOutput       // 输出音频管理对象，输出数据为 NSData
     AVCaptureStillImageDataOutput  // 输出图片管理对象，输出数据为 NSData
     AVCaptureVideoDataOutput       // 输出视频管理对象，输出数据为 NSData
     
     AVCapturePhotoOutput 的功能更加强大，不仅支持简单 JPEG 图片拍摄，还支持 Live 照片和 RAW 格式拍摄。
     
     AVCaptureFileOutput 输出文件管理对象，输出数据以文件形式输出
     子类
     {
     AVCaptureAudioFileOutput   // 输出是音频文件
     AVCaptureMovieFileOutput   // 输出是视频文件
     }
     */
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
    NSDictionary *format = @{
        AVVideoCodecKey: AVVideoCodecTypeJPEG,
    };
    AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:format];
    [self.photoOutput setPhotoSettingsForSceneMonitoring:outputSettings];
    // 添加【输出对象】到会话中
    if ([self.session canAddOutput:self.photoOutput]) {
        [self.session addOutput:self.photoOutput];
    }
    
    /**
     MARK: 4.创建实时预览图层
     
     AVCaptureVideoPreviewLayer 是 CALayer 的子类，可被用于自动显示相机产生的实时图像。它还有几个工具性质的方法，可将 layer 上的坐标转化到设备上。它看起来像输出，但其实不是。另外，它拥有 session (outputs 被 session 所拥有)。
     */
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.view.layer.masksToBounds = YES;
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; //设置比例为铺满全屏
    
    // 【预览图层】插入在【拍照按钮】的下方
    [self.view.layer insertSublayer:self.previewLayer below:self.captureButton.layer];
}

// 将摄像头在前置/后置之间切换
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    
    NSArray *devicesIOS  = devicesIOS10.devices;
    for (AVCaptureDevice *device in devicesIOS) {
        if ([device position] == position) {
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

#pragma mark - Custom Accessors



#pragma mark - Actions

// 打开摄像头
- (IBAction)openCaptureButtonAction:(id)sender {
    
    self.previewLayer.hidden = NO;
    self.captureButton.hidden = NO;
    self.openCaptureButton.hidden = YES;
    
    // 判断相机使用权限
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                [self.session startRunning]; //开始捕捉
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                NSLog(@"相机权限获取失败！");
                break;
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted) {
                            [self.session startRunning]; //开始捕捉
                        } else {
                            NSLog(@"相机权限获取失败！");
                        }
                    });
                }];
                break;
            }
        }
    }
}

// 拍照
- (IBAction)captureButtonAction:(id)sender {

}

#pragma mark - <AVCapturePhotoCaptureDelegate>

/**
 AVCapturePhotoOutput 需要实现 AVCapturePhotoCaptureDelegate 协议，在协议中获取图片。
 */
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    
    NSData *data = [photo fileDataRepresentation];
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark - 保存图像或视频完成的回调

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存图片失败：%@",error.localizedDescription);
    }else {
        NSLog(@"保存图片完成");
    }
}

@end
