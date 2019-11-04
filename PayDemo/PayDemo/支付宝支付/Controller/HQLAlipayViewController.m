//
//  HQLAlipayViewController.m
//  PayDemo
//
//  Created by Qilin Hu on 2019/7/26.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import "HQLAlipayViewController.h"

// Frameworks
// 支付宝支付类库
#import <AlipaySDK/AlipaySDK.h>

// Views


// Models
#import "APOrderInfo.h"

// Utils
#import "APRSASigner.h"

static NSString *const KAliPayOnResponceNotification = @"AliPayOnResponceNotification";

@interface HQLAlipayViewController ()

@end

@implementation HQLAlipayViewController

#pragma mark - Lifecycle

- (void)dealloc {
    // 移除支付宝支付通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 添加支付宝支付通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respondsToAliPayNotification:)
                                                 name:KAliPayOnResponceNotification
                                               object:nil];
}

#pragma mark - Public

#pragma mark - Private

// 点击订单模拟支付行为
- (void)requestPaymentToAlipay {
    
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey 等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的 appID ============================*/
    /*============================================================================*/
    // 注意，集成支付宝支付时，appID 和 privateKey 都是放在服务端的，客户端不需要存储。
    // 客户端放的是 URL Schemes 值。
    NSString *appID = @"";
    
    // 以下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"缺少appId或者私钥,请检查参数设置"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           
                                                       }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{ }];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    /*
     * orderInfo 订单信息
     * orderInfoEncoded 编码后的订单信息
     *
     * RSA 非对称加密算法的私钥 对 「orderInfo 订单信息」 进行签名 -> 生成 signedString
     *
     */
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"appSchema";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        /* 💡💡💡
         * orderString：app 支付请求参数字符串，主要包含商户的订单信息，key=value 形式，以 & 连接。
         *
         * orderString 示例： app_id=2015052600090779&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22seller_id%22%3A%22%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.02%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22314VYGIAGG7ZOYY%22%7D&charset=utf-8&method=alipay.trade.app.pay&sign_type=RSA2&timestamp=2016-08-15%2012%3A12%3A15&version=1.0&sign=MsbylYkCzlfYLy9PeRwUUIg9nZPeN9SfXPNavUCroGKR5Kqvx0nEnd3eRmKxJuthNUx4ERCXe552EV9PfwexqW%2B1wbKOdYtDIb4%2B7PL3Pc94RZL0zKaWcaY3tSL89%2FuAVUsQuFqEJdhIukuKygrXucvejOUgTCfoUdwTi7z%2BZzQ%3D
         *
         *
         * 正常的业务接入流程中，orderString 字符串应该是服务器拼接好之后返回给客户端 APP 的。
         * 客户端 APP 拿到 orderString 后，直接调用下面的方法向「支付宝」发起支付请求就可以了。
         *
         * 所以，上面流程中的步骤其实全都应该由服务器完成，客户端不需要做！！！
         */
        
        // NOTE: 调用支付结果开始支付
        /*
         * 参数说明
         * orderString：app 支付请求参数字符串，主要包含商户的订单信息，key=value 形式，以 & 连接。由业务系统服务端返回。
         * appScheme：商户程序注册的 URL protocol，供支付完成后回调商户程序使用。
         *           由业务人员向支付宝申请开通支付宝支付后，告知 iOS 开发人员，iOS 开发人员写死到代码中。
         *           另外，Targets - Info - URL Types 中 「URL Schemes」也要配置该值。
         * completionBlock：跳转支付宝支付时只有当processOrderWithPaymentResult接口的completionBlock为nil时会使用这个bolock
         */
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

// 响应支付宝支付回调通知，「支付宝 H5 支付」成功后会返回 url，这是通过「支付宝」APP 支付的回调
- (void)respondsToAliPayNotification:(NSNotification *)notification {
    // 支付宝返回参数：<https://docs.open.alipay.com/204/105301/>
    NSDictionary *resultDict = notification.object;
    NSLog(@"支付宝支付返回参数：\n%@",resultDict);
}

// 产生随机订单号
- (NSString *)generateTradeNO {

    static int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
