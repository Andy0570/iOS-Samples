//
//  MBProgressHUD+HQLCategory.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/1.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "MBProgressHUD+HQLCategory.h"
#import <YYKit/NSString+YYAdd.h>

static const NSTimeInterval KAnimationDuration = 3.0;

@implementation MBProgressHUD (HQLCategory)

#pragma mark - 显示自动隐藏 HUD：Image + Label

+ (void)showMBProgressHUDWithText:(NSString *)message
                       imageNamed:(NSString *)name
                           toView:(UIView *)view
                       afterDelay:(NSTimeInterval)delay {
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    NSAssert(name, @"Image name should not be nil.");
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    NSAssert(message, @"Message should not be nil.");
    hud.label.text = message;
    hud.contentColor = [UIColor whiteColor];
    // 设置 HUD窗口为黑色
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.minSize = CGSizeMake(150.f, 100.f);
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    [hud hideAnimated:YES afterDelay:delay];
}

#pragma mark -
#pragma mark 显示带ICON的成功/错误信息，自动消失
+ (void)hql_showSuccessHUD:(NSString *)message toView:(nullable UIView *)view {
    [self showMBProgressHUDWithText:message
                         imageNamed:@"success_white"
                             toView:view
                         afterDelay:KAnimationDuration];
}

+ (void)hql_showSuccessHUD:(NSString *)message {
    [self hql_showSuccessHUD:message toView:nil];
}

+ (void)hql_showFailureHUD:(NSString *)message toView:(nullable UIView *)view {
    [self showMBProgressHUDWithText:([message isNotBlank] ? message : @"")
                         imageNamed:@"failure_white"
                             toView:view
                         afterDelay:KAnimationDuration];
}

+ (void)hql_showFailureHUD:(NSString *)message {
    [self hql_showFailureHUD:message toView:nil];
}


#pragma mark - 文字样式

+ (MBProgressHUD *)hql_showTextHUD:(NSString *)message
                            toView:(nullable UIView *)view {
    
    if (!view)  {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    NSAssert(message, @"Message should not be nil.");
    hud.detailsLabel.text = message;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    // 3秒后自动消失
    [hud hideAnimated:YES afterDelay:KAnimationDuration];
    return hud;
}

+ (MBProgressHUD *)hql_showTextHUD:(NSString *)message {
    return [self hql_showTextHUD:message toView:nil];
}


#pragma mark - 隐藏 HUD

+ (void)hql_hideHUDForView:(nullable UIView *)view {
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hql_hideHUD {
    [self hql_hideHUDForView:nil];
}

@end
