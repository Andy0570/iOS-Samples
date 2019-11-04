//
//  AppDelegate+PayService.m
//  XuZhouSS
//
//  Created by Qilin Hu on 2019/7/27.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "AppDelegate+PayService.h"

// 微信支付
#import <WechatOpenSDK/WXApi.h>
// 支付宝支付
#import <AlipaySDK/AlipaySDK.h>
// 工行e支付
#import <ICBCPaySDK/ICBCPaySDK.h>

// 从微信获取的 appId
static NSString *const KWechatAppId = @"wx5743e120a9070ec8";

static NSString *const KAliPayOnResponceNotification = @"AliPayOnResponceNotification";
static NSString *const KWechatPayOnResponceNotification = @"WechatPayOnResponceNotification";

@interface AppDelegate () <WXApiDelegate>

@end
@implementation AppDelegate (PayService)

#pragma mark - Public

- (void)hql_configureForWechatPay {
    //向微信注册
    [WXApi registerApp:KWechatAppId];
}

#pragma mark - UIApplicationDelegate

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    NSLog(@"%s\n url = %@",__FUNCTION__,url);
    
    if ([url.host isEqualToString:@"safepay"]) {
        // -------- 处理「支付宝」支付回调 --------
        // 跳转支付宝进行支付，处理支付宝客户端返回的支付 url
        // url：支付宝客户端回传的 url
        // completionBlock：本地安装了支付宝客户端，且成功调用支付宝客户端进行支付的情况下，会通过该 completionBlock 返回支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            // 通过通知中心回传支付信息
            [[NSNotificationCenter defaultCenter] postNotificationName:KAliPayOnResponceNotification
                                                                object:(NSDictionary *)resultDic];
        }];
    }else if ([url.absoluteString hasSuffix:@"ICBCB2CPAY"]) {
        // -------- 处理「工行e支付」支付回调 --------
        // 处理微信通过 URL 启动 App 时传递的数据
        // url：微信启动第三方应用时传递过来的URL
        // delegate：WXApiDelegate 对象，用来接收微信触发的消息。
        [[ICBCPaySDK sharedSdk] ICBCResultBackWithUrl:url];
    }else {
        // -------- 处理「微信」支付回调 --------
        [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}

#pragma mark - WXApiDelegate

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp 具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp {
    // 微信支付成功/失败，发起通知查询
    [[NSNotificationCenter defaultCenter] postNotificationName:KWechatPayOnResponceNotification
                                                        object:(BaseReq *)resp];
}

@end
