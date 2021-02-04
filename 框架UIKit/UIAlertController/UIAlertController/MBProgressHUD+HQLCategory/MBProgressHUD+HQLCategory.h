//
//  MBProgressHUD+HQLCategory.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/1.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (HQLCategory)

#pragma mark - 图片+文字样式

/**
 显示成功 HUD，带 Image 和 Label，3 秒后自动消失。

 @param message 描述信息
 @param view 显示HUD的视图
 */
+ (void)hql_showSuccessHUD:(NSString *)message toView:(nullable UIView *)view;

/**
 在窗口显示成功 HUD，带 Image 和 Label，3 秒后自动消失。

 @param message 标签文字
 */
+ (void)hql_showSuccessHUD:(NSString *)message;

/**
 显示失败 HUD，带 Image 和 Label，3 秒后自动消失。

 @param message 描述信息
 @param view 显示HUD的视图
 */
+ (void)hql_showFailureHUD:(NSString *)message toView:(nullable UIView *)view;

/**
 显示失败 HUD，带 Image 和 Label，3 秒后自动消失。

 @param message  描述信息
 */
+ (void)hql_showFailureHUD:(NSString *)message;


#pragma mark - 文字样式

/**
 中心显示提示标签,3 秒后自动消失

 @param message 描述信息
 @param view 显示HUD的视图
 */
+ (MBProgressHUD *)hql_showTextHUD:(NSString *)message toView:(nullable UIView *)view;

/**
 在窗口显示提示标签 HUD,3 秒后自动消失

 @param message 描述信息
 */
+ (MBProgressHUD *)hql_showTextHUD:(NSString *)message;


#pragma mark - 隐藏 HUD

+ (void)hql_hideHUDForView:(nullable UIView *)view;
+ (void)hql_hideHUD;

@end

NS_ASSUME_NONNULL_END
