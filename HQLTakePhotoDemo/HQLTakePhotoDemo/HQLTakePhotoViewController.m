//
//  HQLTakePhotoViewController.m
//  XuZhouSS
//
//  Created by ToninTech on 2016/12/15.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLTakePhotoViewController.h"
// 需要导入：<MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <YYKit.h>

#define ThemeColor [UIColor colorWithDisplayP3Red:81/255.0 green:136/255.0 blue:247/255.0 alpha:1.0]

@interface HQLTakePhotoViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate> 

// 显示拍摄的照片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HQLTakePhotoViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setNavigationControllerAppearance];
}

#pragma mark - IBAction

// 拍照
- (IBAction)takePicture:(UIButton *)sender {
    
    // 1️⃣ 创建 UIImagePickerController 对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    // 检查设备硬件是否可用
    BOOL isSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!isSourceTypeAvailable) {
        // 显示弹窗
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"启动相机失败,您的相机功能未开启，请转到手机设置中开启相机权限!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
        /*
         2️⃣ 设置sourceType
         UIImagePickerControllerSourceType:
         UIImagePickerControllerSourceTypePhotoLibrary,    // 照片库
         UIImagePickerControllerSourceTypeCamera,          // 像机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相册
         */
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        /*
         摄像头捕捉模式
        UIImagePickerControllerCameraCaptureMode:
        UIImagePickerControllerCameraCaptureModePhoto, // 拍照模式，默认
        UIImagePickerControllerCameraCaptureModeVideo   // 视频录制模式
         */
        
        // 【拍照模式】
        // 设定拍照的媒体类型
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        // 设置摄像头捕捉模式为捕捉图片，默认
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        /*
           【录像模式】
        // 设定录像的媒体类型
        imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        // 设置摄像头捕捉模式为捕捉视频
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        */
        
        /*
         摄像头设备
         UIImagePickerControllerCameraDevice:
         UIImagePickerControllerCameraDeviceRear,   //后置摄像头，默认
         UIImagePickerControllerCameraDeviceFront   //前置摄像头
         */
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
        /*
         设置图片质量
         UIImagePickerControllerQualityType:
         UIImagePickerControllerQualityTypeHigh // highest quality
         UIImagePickerControllerQualityTypeMedium // medium quality, suitable for transmission via Wi-Fi
         UIImagePickerControllerQualityTypeLow // lowest quality, suitable for tranmission via cellular network
         UIImagePickerControllerQualityType640x480 // VGA quality
         UIImagePickerControllerQualityTypeIFrame1280x720
         UIImagePickerControllerQualityTypeIFrame960x540
         */
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        
        
        /*
         闪光灯模式
         typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraFlashMode
         UIImagePickerControllerCameraFlashModeOff  = -1,
         UIImagePickerControllerCameraFlashModeAuto = 0,默认
         UIImagePickerControllerCameraFlashModeOn   = 1
         */
//        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto
        
    }
    // 3️⃣ 设置delegate
    imagePicker.delegate = self;
    
    
    //显示标准相机UI，自带的摄像头控制面板，默认YES
//    imagePicker.showsCameraControls = NO;
    
    // 4️⃣ 设置覆盖图层
    UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    overlayImageView.image = [UIImage imageNamed:@"mask_green"];
    imagePicker.cameraOverlayView = overlayImageView;
    
    // 5️⃣ 以模态形式显示UIImagePickerController对象
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// 保存照片到系统相册
- (IBAction)UploadPicture:(id)sender {
    NSLog(@"保存照片");
}

#pragma mark - Private

// image 图片转换为 base64 编码
- (NSString *)imageToString:(UIImage *)image {
    // image -> data 转换为JPEG格式，压缩率为0.5
    NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
    // data -> string 将图片转换为base64字符串
    NSString *pictureString = [pictureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return pictureString;
}

- (void)setNavigationControllerAppearance {
    // 设置导航栏标题&字体&颜色
    self.navigationItem.title = @"UIImagePickerController";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:ThemeColor}];
}

#pragma mark - UIImagePickerControllerDelegate

// 拍照完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%s",__func__);
    
    // 从info取出此时摄像头的媒体类型
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 【拍照模式】
        // 通过info字典获取选择的照片
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        // 将照片放入UIImageView对象显示在UI界面
        self.imageView.image = image;
        
        // 保存图像到相簿
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        // 【录像模式】
        // 获取录像文件路径URL
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSString *path = url.path;
        
        // 判断能否保存到相簿
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            // 保存视频到相簿
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    // 关闭UIImagePickerController对象
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"%s",__func__);
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 保存图像或视频完成的回调

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存图片失败：%@",error.localizedDescription);
    }else {
        NSLog(@"保存图片完成");
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败：%@",error.localizedDescription);
    }else {
        NSLog(@"保存视频完成");
    }
}

@end
