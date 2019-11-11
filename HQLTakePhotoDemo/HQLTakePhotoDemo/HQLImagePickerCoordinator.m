//
//  HQLImagePickerCoordinator.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/3/1.
//  Copyright © 2017年 ToninTech. All rights reserved.
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

- (void)setImageSourceType:(UIImagePickerControllerSourceType)sourceType {
    
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

#pragma mark - UIImagePickerControllerDelegate

// 完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        // 取出图片
        UIImage *editedImage = info[UIImagePickerControllerEditedImage];
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        
        if ([self.delegate respondsToSelector:@selector(resultPickingImage:)]) {
            if (editedImage) {
                [self.delegate resultPickingImage:editedImage];
            } else {
                [self.delegate resultPickingImage:originalImage];
            }
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
