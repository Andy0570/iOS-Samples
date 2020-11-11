//
//  HQLCamera02ViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/10.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCamera02ViewController.h"

// Framework
#import <MobileCoreServices/MobileCoreServices.h>
#import <HXPhotoPicker.h>
#import <JKCategories/UIView+JKToast.h>

// Tool
#import "IDPermissionsManager.h"

#define ThemeColor [UIColor colorWithDisplayP3Red:81/255.0 green:136/255.0 blue:247/255.0 alpha:1.0]

@interface HQLCamera02ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation HQLCamera02ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationControllerApperance];
    
    // 适配深色模式，动态设置背景颜色
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            BOOL isDarkMode = (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
            return isDarkMode ? UIColor.blackColor : UIColor.whiteColor;
        }];
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
}

// 设置导航栏标题&字体&颜色
- (void)setNavigationControllerApperance {
    self.navigationItem.title = @"图片选择器";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:ThemeColor}];
}

#pragma mark - Custom Accessors

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - Actions

- (IBAction)pickPhoto:(id)sender {
    // MARK: 检查系统相机权限
    __weak __typeof(self)weakSelf = self;
    [IDPermissionsManager requestCameraPermissionWithCompletionhandle:^(BOOL granted) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (granted) {
            [strongSelf showBottomSelectView];
        } else {
            [strongSelf.view jk_makeToast:@"请先打开相机权限~"];
        }
    }];
}

// MARK: 通过 <HXPhotoPicker> 框架中的 HXPhotoBottomSelectView 类实现弹窗效果
- (void)showBottomSelectView {
    // 1.设置 cell 数据源模型
    HXPhotoBottomViewModel *cameraModel = [[HXPhotoBottomViewModel alloc] init];
    cameraModel.title = @"拍摄";
    cameraModel.subTitle = @"照片或视频";
    
    HXPhotoBottomViewModel *photoModel = [[HXPhotoBottomViewModel alloc] init];
    photoModel.title = @"从手机相册选择";
    
    NSArray *cellModels = @[cameraModel, photoModel];
    
    // 2.弹窗
    __weak __typeof(self)weakSelf = self;
    [HXPhotoBottomSelectView showSelectViewWithModels:cellModels selectCompletion:^(NSInteger index, HXPhotoBottomViewModel * _Nonnull model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (index == 0) {
            [strongSelf setSourceTypeCamera];
        } else {
            [strongSelf setSourceTypePhotoLibrary];
        }
    } cancelClick:nil];
}

#pragma mark - Private

// MARK: 打开相机
- (void)setSourceTypeCamera {
    // 检查设备硬件是否可用
    BOOL isSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (isSourceTypeAvailable) {
        
        // 设置 sourceType 媒体数据源类型：使用后置摄像头打开相机，自动闪光灯
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设定拍照的媒体类型，照片或者视频
        self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage, (NSString*)kUTTypeMovie];
        // 设置摄像头捕捉模式为捕捉图片，默认
        self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        // 设置摄像头硬件类型，默认为后置摄像头
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else {
            [self.view jk_makeToast:@"相机不可用，请检查后再试～"];
            return;
        }

        // 设置图片质量为高质量，默认中等。
        self.imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;

        // 设置闪光灯模式，自动
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        
        // 允许编辑
        self.imagePickerController.allowsEditing = YES;
        
        // 以模态样式呈现照片选择器
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [self.view jk_makeToast:@"相机不可用，请检查后再试～"];
    }
}

// MARK: 打开相册
- (void)setSourceTypePhotoLibrary {
    BOOL isSourceTypeAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (isSourceTypeAvailable) {
        
        // 设置 sourceType 媒体数据源类型：打开相册
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // 以模态样式呈现照片选择器
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [self.view jk_makeToast:@"无法打开相册，请检查权限后再试～"];
    }
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        // 1. 如果返回的是图片，获取图片
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        if (originalImage) {
            self.imageView.image = originalImage;
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    } else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
        // 2. 如果返回的是视频，获取视频 url
        NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        // 判断能否保存到相簿
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path)) {
            // 保存视频到相册
            UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
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

#pragma mark - Override

// 重写方法，监控特性集合（traitCollection）属性的变换，适配深色模式
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        [self preferredStatusBarUpdateAnimation];
        [self changeStatus];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        // 获取当前的主题外观（UIUserInterfaceStyle）设置：浅色模式/深色模式
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return UIStatusBarStyleLightContent;
        }
    }
    return UIStatusBarStyleDefault;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
- (void)changeStatus {
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            return;
        }
    }
#endif
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}
#pragma clang diagnostic pop

@end
