//
//  IDCameraPermissionsManager.m
//  VideoCameraDemo
//
//  Created by Adriaan Stellingwerff on 10/03/2014.
//  Copyright (c) 2014 Infoding. All rights reserved.
//

#import "IDPermissionsManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@implementation IDPermissionsManager

+ (BOOL)cameraPermissions {
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
            [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = NO;
                break;
        }
    }
    
    return isHavePemission;
}

+ (void)requestCameraPemissionWithCompletionHandle:(void(^)(BOOL granted))completion {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
            [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
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
                        }else {
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
