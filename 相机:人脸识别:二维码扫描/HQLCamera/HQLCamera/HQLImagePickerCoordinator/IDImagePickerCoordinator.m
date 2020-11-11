//
//  IDImagePickerCoordinator.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "IDImagePickerCoordinator.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

@interface IDImagePickerCoordinator () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation IDImagePickerCoordinator

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _imagePicker = [self setupImagePicker];
    }
    return self;
}

- (UIImagePickerController *)setupImagePicker {
    UIImagePickerController *imagePicker;
    // 是否支持拍摄视频
    if([self isVideoRecordingAvailable]){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePicker.delegate = self;
    }
    return imagePicker;
}

#pragma mark - Custom Accessors

- (UIImagePickerController *)imagePicker {
    return _imagePicker;
}

#pragma mark - Private

- (BOOL)isVideoRecordingAvailable {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)setFrontFacingCameraOnImagePicker:(UIImagePickerController *)picker {
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
        [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
        return YES;
    }
    return NO;
}

- (void)configureCustomUIOnImagePicker:(UIImagePickerController *)picker {
    UIView *cameraOverlay = [[UIView alloc] init];
    picker.showsCameraControls = NO;
    picker.cameraOverlayView = cameraOverlay;
}

#pragma mark - UIImagePickerControllerDelegate

// 完成选择视频
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    // 从 info 中获取此时摄像头的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqual:(NSString *)kUTTypeMovie]) {
        NSURL *recordedVideoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // !!!: 使用 <Photos/Photos.h> 框架保存视频
        PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
        [photoLibrary performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:recordedVideoURL];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                // 已将视频保存到相册...
                [picker dismissViewControllerAnimated:YES completion:NULL];
            } else {
                // 未能保存视频到相册
                NSLog(@"Error:\n%@",error);
            }
        }];
    }
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
