//
//  HQLICBCPayViewController.m
//  PayDemo
//
//  Created by Qilin Hu on 2019/7/27.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import "HQLICBCPayViewController.h"

// Frameworks
#import <ICBCPaySDK/ICBCPaySDK.h>

@interface HQLICBCPayViewController () <ICBCPaySDKDelegate>

@end

@implementation HQLICBCPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 发起工行e支付
- (void)requestPaymentToAlipay {
    
    ICBCPaySDK *shareSDK = [ICBCPaySDK sharedSdk];
    shareSDK.sdkDelegate = self;
    
    // 测试环境，请配置 urlListmain 和 urlPortal
    // 两个地址，在测试环境请配置模测地址，以便于在出现问题的时候查找日志。具体模测环境的搭建请联系数据中心的同事。
    // ======= 生产地址 ========
//    shareSDK.urlListMain = @"https://b2c.icbc.com.cn"; // 支付平台地址
//    shareSDK.urlPortal = @"https://mywap2.icbc.com.cn"; //手机银行地址
    
    // ======= 模测环境地址 ========
    shareSDK.urlListMain = @"https://b2c3.dccnet.com.cn"; // 支付平台地址
    shareSDK.urlPortal = @"https://mywap2.dccnet.com.cn:447"; //手机银行地址
    
    // 构造交易信息
    NSMutableDictionary *testDict = [[NSMutableDictionary alloc] init];
    testDict[@"urlScheme"] = @"urlSchema"; // 应用包名，必须传入，否则跳转至工行App无法返回
    testDict[@"interfaceName"] = @"interfaceName"; // 接口名
    testDict[@"interfaceVersion"] = @"interfaceVersion"; // 接口版本号
    testDict[@"tranData"] = @"tranData"; // 交易信息
    testDict[@"merSignMsg"] = @"merSignMsg"; // 交易信息签名
    testDict[@"merCert"] = @"merCert"; // 商户公钥文件信息
    
    // 发起工行支付
    [shareSDK presentICBCPaySDKInViewController:self andTraderInfo:testDict];
    
}

#pragma mark - ICBCPaySDKDelegate

/**
 *  调用工银e支付以后的结果回调
 *
 *  @param dic        回调的字典，参数中，ret_msg会有具体错误显示
 */
- (void)paymentEndwithResultDic:(NSDictionary*)dic {
    /*
     * 返回的字典格式：
     *   tranCode: 交易结果代码
     *   tranMsg: 交易结果信息
     *   orderNo: 交易订单号
     *
     * 此处，由于系统原因在极少的情况下，可能出现 trancode 为空的情况，交易结果主要通过 tranMsg 体现，
     * 所以，请主要判断tranMsg，判断tranMsg中是否包含成功失败字样等等。
     * tranCode 与 tranMsg 的对应关系：
     * 1--交易成功，已清算
     * 2--交易失败
     * 3--交易可疑
     * 4--用户中止交易
     */
    
}

/**
 *  调用微信以后的结果回调
 *
 *  @param dic        回调的字典，参数中，errCode会有具体错误显示
 */
-(void)wxPayEndwithResultDic:(NSDictionary*)dic {
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    int errorCode = (int)[dic objectForKey:@"errCode"];
    NSString *errStr = [dic objectForKey:@"errStr"];
    switch (errorCode) {//?这个可能应该写成枚举
        case 0:
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", errorCode);
            NSLog(@"商户自行处理");
            break;
            
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", errorCode,errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", errorCode,errStr);
            NSLog(@"商户自行处理");
            break;
    }
}

/**
 *  调用支付宝支付以后的结果回调
 *
 *  @param dic        回调的字典，参数中，errCode会有具体错误显示
 */
-(void)aliPayEndwithResultDic:(NSDictionary*)dic {
    NSLog(@"支付宝支付返回结果 :%@",dic);
    //    resultStatus，状态码，SDK里没对应信息，第一个文档里有提到：
    //    9000 订单支付成功
    //    8000 正在处理中
    //    4000 订单支付失败
    //    6001 用户中途取消
    //    6002 网络连接出错
//    memo， 提示信息，比如状态码为6001时，memo就是“用户中途取消”。但是此提示语并不是太准确 最好自己定义成功或者失败的提示
//    result，订单信息，以及签名验证信息
    
}

@end
