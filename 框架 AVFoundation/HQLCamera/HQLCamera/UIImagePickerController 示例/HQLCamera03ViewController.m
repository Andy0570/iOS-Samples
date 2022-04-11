//
//  HQLCamera03ViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCamera03ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <JKCategories/UIView+JKToast.h>

@interface HQLCamera03ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController; // 图片拾取器
@end

@implementation HQLCamera03ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImagePickerController];
}

// 初始化图片拾取器
- (void)initImagePickerController {
    // 创建 UIImagePickerController 示例对象
    self.imagePickerController = [[UIImagePickerController alloc] init];
    
    // 检查设备硬件是否可用
    BOOL isSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!isSourceTypeAvailable) {
        [self.view jk_makeToast:@"相机不可用，请检查后再试～"];
        return;
    }
    // 设置拾取源为摄像头
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 设置摄像头硬件类型，默认为后置摄像头
    BOOL isCameraDeviceAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCameraDeviceAvailable) {
        [self.view jk_makeToast:@"相机不可用，请检查后再试～"];
        return;
    }
    // 设置后置摄像头
    self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;

    // 设置运行编辑，即可以点击一些拾取控制器的控件
    self.imagePickerController.allowsEditing = YES;
    
    // 设置代理，通过 delegate 获取返回的媒体资源
    self.imagePickerController.delegate = self;
}

#pragma mark - Actions

// MARK: 点击拍照
- (IBAction)imagePicker:(id)sender {
    // 设定拍照的媒体类型，照片
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    // 设置摄像头捕捉模式为捕捉图片
    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    // 以模态样式呈现照片选择器
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

// MARK: 点击录像
- (IBAction)videoPicker:(id)sender {
    // 设定拍照的媒体类型，视频
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
    // 设置摄像头捕捉模式为捕捉视频
    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    // 设置视频质量为高清
    self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    // 以模态样式呈现照片选择器
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>

// 拍照或录像成功，都会调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 从 info 中获取此时摄像头的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 如果是拍照，获取拍照的图形
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        // 保存图像到相簿
        UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        // 如果是视频，获取视频文件 URL 路径
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        // 判断能否保存到相簿
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path)) {
            // 保存视频到相册
            UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 取消拍照或录像会调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片或视频完成的回调

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存图片失败：%@",error.localizedDescription);
    }else {
        NSLog(@"保存图片完成");
        self.imageView.image = image;
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
