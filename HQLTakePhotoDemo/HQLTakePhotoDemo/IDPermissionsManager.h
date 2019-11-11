//
//  IDCameraPermissionsManager.h
//  VideoCameraDemo
//
//  Created by Adriaan Stellingwerff on 10/03/2014.
//  Copyright (c) 2014 Infoding. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 相机权限管理
 */
@interface IDPermissionsManager : NSObject

/**
 返回当前相机权限状态

 @return 权限状态
 */
+ (BOOL)cameraPermissions;

/**
 请求访问媒体类型的底层硬件

 @param completion 请求访问成功/失败 的 Block 回调
 */
+ (void)requestCameraPemissionWithCompletionHandle:(void(^)(BOOL granted))completion;

@end
