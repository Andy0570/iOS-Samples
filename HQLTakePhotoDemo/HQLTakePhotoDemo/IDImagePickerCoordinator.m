//
//  IDImagePickerCoordinator.m
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 1/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "IDImagePickerCoordinator.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface IDImagePickerCoordinator () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *camera;

@end

@implementation IDImagePickerCoordinator


- (instancetype)init
{
    self = [super init];
    if(self){
        _camera = [self setupImagePicker];
    }
    return self;
}

- (UIImagePickerController *)cameraVC
{
    return _camera;
}

#pragma mark - Private methods

- (UIImagePickerController *)setupImagePicker
{
    UIImagePickerController *camera;
    if([self isVideoRecordingAvailable]){
        camera = [UIImagePickerController new];
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.mediaTypes = @[(NSString *)kUTTypeMovie];
        camera.delegate = self;
    }
    return camera;
}


- (BOOL)isVideoRecordingAvailable
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)setFrontFacingCameraOnImagePicker:(UIImagePickerController *)picker
{
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
        [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
        return YES;
    }
    return NO;
}

- (void)configureCustomUIOnImagePicker:(UIImagePickerController *)picker
{
    UIView *cameraOverlay = [[UIView alloc] init];
    picker.showsCameraControls = NO;
    picker.cameraOverlayView = cameraOverlay;
}

#pragma mark - UIImagePickerControllerDelegate methods

// 完成选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    // 通过设置代理回调
}

// 完成选择视频
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // FIXME: ALAssetsLibrary 自 iOS 9.0 开始失效
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSURL *recordedVideoURL= [info objectForKey:UIImagePickerControllerMediaURL];
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL]) {
        
        // 保存到系统相册
        [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
                                    completionBlock:^(NSURL *assetURL, NSError *error){}
         ];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
