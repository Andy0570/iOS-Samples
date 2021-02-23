//
//  HQLAVFoundation01ViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLAVFoundation01ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <JKCategories.h>

#define ThemeColor [UIColor colorWithDisplayP3Red:81/255.0 green:136/255.0 blue:247/255.0 alpha:1.0]

@interface HQLAVFoundation01ViewController () <AVCapturePhotoCaptureDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *openCaptureButton;

@property (strong, nonatomic) AVCaptureSession *session;                // 媒体管理会话
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput;        // 输入数据对象
@property (strong, nonatomic) AVCapturePhotoOutput *photoOutput;        // 照片输出对象
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer; // 视频预览图层

@end

@implementation HQLAVFoundation01ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationControllerAppearance];
    [self initWithCaptureSession];
    
    self.captureButton.hidden = YES;
    self.openCaptureButton.hidden = NO;
}

// 设置导航栏标题&字体&颜色
- (void)setNavigationControllerAppearance {
    self.navigationItem.title = @"AVFoundation Demo";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:ThemeColor}];
}

#pragma mark - Private

// 初始化摄像头
- (void)initWithCaptureSession {
    
    /**
     MARK: 1.创建媒体管理会话
     
     AVCaptureSession 是媒体捕捉会话，管理输入与输出之间的数据流，以及在出现问题时生成运行时错误。
     负责把捕获到的音频视频数据输出到输出设备上，一个会话可以有多个输入输入。
     */
    self.session = [[AVCaptureSession alloc] init];
    // 判断拍摄分辨率是否支持 1280*720，支持就设置为 1280*720
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    /**
     MARK: 2. 获取后置摄像头
     
     AVCaptureDevice 是关于相机硬件的接口。它被用于控制硬件特性，诸如镜头的位置、曝光、闪光灯等。
     */
    AVCaptureDevice *captureDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice) {
        [self.view jk_makeToast:@"无法获取后置摄像头！"];
        return;
    }
    
    /**
     MARK: 3. 创建输入数据对象
     
     AVCaptureDeviceInput 设备输入数据管理对象，管理输入数据
     */
    NSError *error = nil;
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error) {
        [self.view jk_makeToast:@"创建视频输入数据对象错误！"];
        return;
    }
    // 将「输入数据对象」添加到会话中
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
    
    // 将「输出数据对象」添加到会话中
    if ([self.session canAddOutput:self.photoOutput]) {
        [self.session addOutput:self.photoOutput];
        
        // MARK: 添加防抖功能
        AVCaptureConnection *connection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    /**
     MARK: 4.创建实时预览图层
     
     AVCaptureVideoPreviewLayer 是 CALayer 的子类，可被用于自动显示相机产生的实时图像。它还有几个工具性质的方法，可将 layer 上的坐标转化到设备上。它看起来像输出，但其实不是。另外，它拥有 session (outputs 被 session 所拥有)。
     */
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.view.layer.masksToBounds = YES;
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; //设置比例为铺满全屏
    // 将「实时预览图层」添加到「拍摄按钮的下方」
    [self.view.layer insertSublayer:self.previewLayer below:self.captureButton.layer];
}

/**
 AVCaptureDeviceType 枚举类型：
 
 AVCaptureDeviceTypeBuiltInMicrophone // 创建麦克风
 AVCaptureDeviceTypeBuiltInWideAngleCamera // 创建广角摄像头
 AVCaptureDeviceTypeBuiltInTelephotoCamera // 创建比广角相机更长的焦距。只有使用 AVCaptureDeviceDiscoverySession 可以使用
 AVCaptureDeviceTypeBuiltInDualCamera // 创建变焦的相机，可以实现广角和变焦的自动切换。使用同 AVCaptureDeviceTypeBuiltInTelephotoCamera 一样。
 AVCaptureDeviceTypeBuiltInDuoCamera //iOS 10.2 被 AVCaptureDeviceTypeBuiltInDualCamera 替换
 */
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

// 将摄像头在前置/后置之间切换
- (void)swapFrontAndBackCameras {
    // Assume the session is already running
    
    for (AVCaptureDeviceInput *input in self.session.inputs) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront) {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            } else {
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            }
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

#pragma mark - Action

// 拍摄静态照片
- (IBAction)captureButtonAction:(id)sender {
    // 设置照片方向
    AVCaptureConnection *connection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.supportsVideoOrientation) {
        connection.videoOrientation = self.previewLayer.connection.videoOrientation;
    }
    
    /*
     创建并配置 AVCapturePhotoSettings 对象以选择特定拍摄的功能和设置
     flashMode: 闪光灯模式
     autoStillImageStabilizationEnabled: 自动静态图片稳定 (防抖)
     highResolutionPhotoEnabled: 指定输出摄像头支持的最高质量图像
     livePhotoMovieFileURL: 实况照片保存路径
     */
    if ([self.photoOutput.availablePhotoCodecTypes containsObject:AVVideoCodecTypeJPEG]) {
        NSDictionary *format = @{AVVideoCodecKey: AVVideoCodecTypeJPEG}; // 配置视频编码
        AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettingsWithFormat:format];
        [self.photoOutput setPhotoSettingsForSceneMonitoring:photoSettings];
        
        /**
         AVCapturePhotoQualityPrioritization - 表示照片质量与速度的优先级
         AVCapturePhotoQualityPrioritizationSpeed 表示照片传输的速度是最重要的，即使牺牲质量也在所不惜。
         AVCapturePhotoQualityPrioritizationBalanced（平衡）表示照片质量和传输速度优先平衡。
         AVCapturePhotoQualityPriorityQuality 表示照片质量是最重要的，即使牺牲拍摄到的时间。
         */
        photoSettings.photoQualityPrioritization = self.photoOutput.maxPhotoQualityPrioritization; // 拍摄最高质量
        
        // 设置遵守 AVCapturePhotoCaptureDelegate 协议，以获取图片
        [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self];
    }
}

// 打开摄像头
- (IBAction)openCaptureButtonAction:(id)sender {
    
    self.previewLayer.hidden = NO;
    self.captureButton.hidden = NO;
    self.openCaptureButton.hidden = YES;
    
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

#pragma mark - <AVCapturePhotoCaptureDelegate>

/**
 AVCapturePhotoOutput 需要实现 AVCapturePhotoCaptureDelegate 协议，在协议中获取图片。
 
 AVCapturePhotoCaptureDelegate 协议中的 5 个方法：
 1.拍照配置的确定: willBeginCapture
 2.开始曝光: willCapturePhoto
 3.曝光结束: didCapturePhoto
 4.拍照结果返回: didFinishProcessingPhoto
 5.拍照完成: didFinishCapture
 */
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error {
    NSData *data = [photo fileDataRepresentation];
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark - 保存图像或视频完成的回调

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    // 停止拍摄
    [self.session stopRunning];
    self.previewLayer.hidden = YES;
    
    if (error) {
        NSLog(@"保存图片失败：%@",error.localizedDescription);
    }else {
        NSLog(@"保存图片完成");
        self.imageView.image = image;
    }
}

@end
