//
//  HQLWeChatPayViewController.m
//  PayDemo
//
//  Created by Qilin Hu on 2019/7/25.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import "HQLWeChatPayViewController.h"

// Frameworks
// 微信支付类库
#import <WechatOpenSDK/WXApi.h>
#import <WechatOpenSDK/WXApiObject.h>
// 其他框架类库
#import <YYKit/NSObject+YYModel.h>
#import <MBProgressHUD/MBProgressHUD.h>

// Models
#import "HQLWechatPayRequestModel.h"

static NSString *const KWechatPayOnResponceNotification = @"KWechatPayOnResponceNotification";

@interface HQLWeChatPayViewController ()

@end

@implementation HQLWeChatPayViewController

#pragma mark - Lifecycle

- (void)dealloc {
    // 移除微信支付通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加微信支付通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respondsToWechatPayNotification:)
                                                 name:KWechatPayOnResponceNotification
                                               object:nil];
}

#pragma mark - Private

// 发起支付请求
- (void)dealWithOrderPay {
    // 业务逻辑，先向服务器发起预支付请求，服务器返回支持订单信息。
    // ...
    
    // 先判断是否支持微信支付
    if ([self isSupportWechatPay]) {
        // 解析服务端返回的支付参数
        NSDictionary *payDictionary;
        // 使用 YYModel 将 JSON 数据转化为数据模型 HQLWechatPayRequestModel
        HQLWechatPayRequestModel *payRequestModel = [HQLWechatPayRequestModel modelWithJSON:payDictionary];
        // 向微信终端发起支付的消息结构体
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = payRequestModel.partnerid;
        request.prepayId = payRequestModel.prepayid;
        request.package = payRequestModel.package;
        request.nonceStr = payRequestModel.noncestr;
        request.timeStamp = payRequestModel.timestamp;
        request.sign = payRequestModel.sign;
        // 发起微信支付
        [WXApi sendReq:request];
    }
}

// 响应微信支付回调通知
- (void)respondsToWechatPayNotification:(NSNotification *)notification {
    BaseResp *responds = notification.object;
    switch (responds.errCode) {
        case WXSuccess: {
            // 1. 微信支付成功
            [self showMBProgressHudWithString:@"微信支付成功"];
            break;
        }
        case WXErrCodeCommon: {
            // 2. 微信支付失败
            [self showMBProgressHudWithString:@"微信支付失败"];
            break;
        }
        case WXErrCodeUserCancel: {
            // 3. 用户点击取消并返回
            // ...
            break;
        }
        default: {
            break;
        }
    }
}

// 判断用户设备是否支持微信支付
- (BOOL)isSupportWechatPay {
    // 1.判断是否安装微信
    if (![WXApi isWXAppInstalled]) {
        // 业务代码，提示微信未安装...
        [self showMBProgressHudWithString:@"微信未安装"];
        return NO;
    }
    // 2.判断微信的版本是否支持最新API
    if (![WXApi isWXAppSupportApi]) {
        // 业务代码，提示微信当前版本不支持此功能...
        [self showMBProgressHudWithString:@"您的微信当前版本不支持此功能"];
        return NO;
    }
    return YES;
}

- (void)showMBProgressHudWithString:(NSString *)string {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(string, @"HUD message title");
    // 移动到底部中心
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    // 3秒后自动消失
    [hud hideAnimated:YES afterDelay:3.f];
}


@end
