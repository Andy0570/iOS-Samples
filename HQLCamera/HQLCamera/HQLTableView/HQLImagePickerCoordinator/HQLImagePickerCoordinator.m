//
//  HQLImagePickerCoordinator.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLImagePickerCoordinator.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface HQLImagePickerCoordinator () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong, readwrite) UIImagePickerController *imagePickerController;
@end

@implementation HQLImagePickerCoordinator

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - Custom Accessors

- (BOOL)isCameraAvailable {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isPhotoLibraryAvailable {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return YES;
    }
    return NO;
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

#pragma mark - Public

- (void)setImagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType {
    switch (sourceType) {
        case UIImagePickerControllerSourceTypeCamera: {
            [self setFrontFacingCamera]; // 拍照时默认为前置摄像头
            break;
        }
        case UIImagePickerControllerSourceTypePhotoLibrary:
        case UIImagePickerControllerSourceTypeSavedPhotosAlbum: {
            if ([self isPhotoLibraryAvailable]) {
                self.imagePickerController.sourceType = sourceType;
            }
            break;
        }
    }
}

#pragma mark - Private methods

// 设置前置相机
- (void)setFrontFacingCamera {
    if (![self isCameraAvailable]) {
        return;
    }
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    self.imagePickerController.delegate = self;
    self.imagePickerController.videoQuality = UIImagePickerControllerQualityType640x480;
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [self.imagePickerController setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    }
}

#pragma mark - <UIImagePickerControllerDelegate>

// 完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    // 从 info 中获取此时摄像头的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqual:(NSString *)kUTTypeImage]) {
        // 拍照模式
        // 通过 info 字典获取选择的照片
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // 回调返回图片
        if (self.delegate && [self.delegate respondsToSelector:@selector(resultPickingImage:)]) {
            if (editedImage) {
                [self.delegate resultPickingImage:editedImage];
            } else {
                [self.delegate resultPickingImage:originalImage];
            }
        }

        // 保存图片到相册
        UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
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
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
