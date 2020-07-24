//
//  HQLTakePhotoViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLTakePhotoViewController.h"

// Framework
#import <MobileCoreServices/MobileCoreServices.h>
#import <JKCategories.h>

#define ThemeColor [UIColor colorWithDisplayP3Red:81/255.0 green:136/255.0 blue:247/255.0 alpha:1.0]

@interface HQLTakePhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// 显示拍摄的照片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation HQLTakePhotoViewController

#pragma mark - Initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationControllerApperance];
}

- (void)setNavigationControllerApperance {
    // 设置导航栏标题&字体&颜色
    self.navigationItem.title = @"UIImagePickerController";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:ThemeColor}];
}

#pragma mark - Custom Accessors

#pragma mark - Actions

// 拍照
- (IBAction)takePhone:(id)sender {
    
    // MARK: 1. 创建 UIImagePickerController 对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // 检查设备硬件是否可用
    BOOL isSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!isSourceTypeAvailable) {
        // 弹窗提示，相机权限未打开
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"启动相机失败，您的相机权限未打开，请到手机设置中开启。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    /**
     MARK: 2. 设置媒体数据源类型
     
     UIImagePickerControllerSourceType:
     UIImagePickerControllerSourceTypePhotoLibrary,    // 照片库
     UIImagePickerControllerSourceTypeCamera,          // 像机
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相册
     */
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    /**
     MARK: 3. 设置摄像头捕捉模式：拍照模式
     
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
    
    /**
     MARK: 4. 设置摄像头硬件类型
     
     UIImagePickerControllerCameraDevice:
     UIImagePickerControllerCameraDeviceRear,   //后置摄像头，默认
     UIImagePickerControllerCameraDeviceFront   //前置摄像头
     */
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    /**
     MARK: 4. 设置图片质量
     
     UIImagePickerControllerQualityType:
     UIImagePickerControllerQualityTypeHigh // highest quality
     UIImagePickerControllerQualityTypeMedium // medium quality, suitable for transmission via Wi-Fi
     UIImagePickerControllerQualityTypeLow // lowest quality, suitable for tranmission via cellular network
     UIImagePickerControllerQualityType640x480 // VGA quality
     UIImagePickerControllerQualityTypeIFrame1280x720
     UIImagePickerControllerQualityTypeIFrame960x540
     */
     imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    
    /**
     MARK: 5. 设置闪光灯模式
     
     typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraFlashMode
     UIImagePickerControllerCameraFlashModeOff  = -1,
     UIImagePickerControllerCameraFlashModeAuto = 0,默认
     UIImagePickerControllerCameraFlashModeOn   = 1
     */
    imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    
    // MARK: 6. 设置delegate
    imagePicker.delegate  = self;
    
    // 显示标准相机UI，自带的摄像头控制面板，默认YES
    // imagePicker.showsCameraControls = NO;
    
    // MARK: 7. 设置自定义图层
    CGRect frame = CGRectMake(0, 0, UIScreen.jk_width, UIScreen.jk_height);
    UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:frame];
    overlayImageView.image = [UIImage imageNamed:@"mask_green"];
    imagePicker.cameraOverlayView = overlayImageView;
    
    // MARK: 8. 以模态形式显示 UIImagePickerController 实例对象
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (IBAction)saveImageToAlbums:(id)sender {
    // TODO: 上传图片到服务器
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

#pragma mark - <UIImagePickerControllerDelegate>

// 拍照完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    // 从 info 中获取此时摄像头的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqual:(NSString *)kUTTypeImage]) {
        // 拍照模式
        // 通过 info 字典获取选择的照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // 将照片显式在 UI 页面
        self.imageView.image = image;
        
        // 保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    } else if ([mediaType isEqual:(NSString *)kUTTypeMovie]) {
        // 录像模式
        // 获取视频文件路径 URL
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // 判断能否保存到相簿
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)) {
            // 保存视频到相簿
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// 取消拍照
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [picker dismissViewControllerAnimated:YES completion:NULL];
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
