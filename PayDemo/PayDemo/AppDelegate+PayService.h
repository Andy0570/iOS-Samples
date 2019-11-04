//
//  AppDelegate+PayService.h
//  XuZhouSS
//
//  Created by Qilin Hu on 2019/7/27.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 集成第三方支付服务：微信、支付宝、工行e支付
 
 参考文档：
 微信：<https://open.weixin.qq.com/>
 支付宝：<https://docs.open.alipay.com/204/105295>
 */
@interface AppDelegate (PayService)

// 微信支付配置方法
- (void)hql_configureForWechatPay;

@end

NS_ASSUME_NONNULL_END
