//
//  IDPermissionsManager.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CameraPermissionWithCompletionhandle)(BOOL granted);

/// 相机权限管理器
@interface IDPermissionsManager : NSObject

// 返回当前相机权限状态
+ (BOOL)cameraPermissions;


/// 请求访问媒体类型的底层硬件
/// @param completion 请求访问成功/失败 的 Block 回调
+ (void)requestCameraPermissionWithCompletionhandle:(CameraPermissionWithCompletionhandle)completion;


// 返回当前相机授权权限
+ (void)cameraAuthorizationStatusForMediaType:(AVMediaType)cameraMediaType completionHandler:(void (^)(BOOL granted))handler;

@end

NS_ASSUME_NONNULL_END
