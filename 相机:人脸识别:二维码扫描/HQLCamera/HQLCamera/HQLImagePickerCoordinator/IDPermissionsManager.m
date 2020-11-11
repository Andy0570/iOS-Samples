//
//  IDPermissionsManager.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "IDPermissionsManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@implementation IDPermissionsManager

// 返回当前相机权限状态
+ (BOOL)cameraPermissions {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                return YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusNotDetermined:
                return NO;
                break;
        }
    }
    return NO;
}


/// 请求访问媒体类型的底层硬件
/// @param completion 请求访问成功/失败 的 Block 回调
+ (void)requestCameraPermissionWithCompletionhandle:(CameraPermissionWithCompletionhandle)completion {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted) {
                            completion(YES);
                        } else {
                            completion(NO);
                        }
                    });
                }];
                break;
            }
        }
    }
}

@end
