//
//  ICBCPaySDK.h
//  ICBCPayDemo
//
//  Created by wq on 16/9/26.
//  Copyright © 2016年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PayWay) {
    ICBCePay   = 22,
    WeChatPay  = 23,
    AliPay     = 24
};
@protocol ICBCPaySDKDelegate <NSObject>
@required
/**
 *  调用工银e支付以后的结果回调
 *
 *  @param dic        回调的字典，参数中，ret_msg会有具体错误显示
 */
- (void)paymentEndwithResultDic:(NSDictionary*)dic;

/**
 *  调用微信以后的结果回调
 *
 *  @param dic        回调的字典，参数中，errCode会有具体错误显示
 */
-(void)wxPayEndwithResultDic:(NSDictionary*)dic;

/**
 *  调用支付宝支付以后的结果回调
 *
 *  @param dic        回调的字典，参数中，errCode会有具体错误显示
 */
-(void)aliPayEndwithResultDic:(NSDictionary*)dic;

///**
//    巨富通
// *  支付宝遮罩关闭
// *
// */
//- (void)sdkMaskGotoClose;
@end

/** 单例作为微信支付的代理 */
@interface ICBCPaySDK : NSObject

/**
 *  单例sdk
 *
 *  @return
 */
+ (ICBCPaySDK *)sharedSdk;

/** 代理 */
@property (nonatomic, weak) id<ICBCPaySDKDelegate> sdkDelegate;

//巨富通
///** 遮罩 */
//@property (nonatomic, strong) UIView *blackMask;
/**
 *  工行支付 支付接口
 *
 *  @param viewController 推出工行支付支付界面的ViewController
 *  @param traderInfo     交易信息
 */
- (void)presentICBCPaySDKInViewController: (UIViewController *)viewController
                            andTraderInfo: (NSDictionary *)traderInfo;

/**
 *  微信支付 支付接口
 *
 *  @param viewController 推出微信支付界面的ViewController
 *  @param traderInfo     交易信息
 */
-(void)presentWeChatInViewController:(UIViewController *)viewController
                       andTraderInfo:(NSDictionary *)traderInfo;

/**
 *  支付宝支付 接口
 *
 *  @param viewController 推出付宝支付界面的ViewController
 *  @param traderInfo     交易信息(现在仅有商户ID)
 */
-(void)presentAlipaySDKViewController:(UIViewController *)viewController
                        andTraderInfo:(NSDictionary *)traderInfo;

/**
 *  支付列表接口 支付接口
 *
 *  @param viewController 推出支付列表的ViewController
 *  @param traderInfo     交易信息
 */
-(void)presentPayListViewController:(UIViewController *)viewController
                            showDic:(NSDictionary *)merID
                      addTraderInfo:(NSDictionary *)traderInfo
                     addTraderInfo2:(NSDictionary *)traderInfo2;

/**
 *  支付列表接口 支付完成后退出sdk支付列表页返回商户APP接口 只需要调用支付列表的商户实现
 *
 */
- (void)exitICBCPaySDK;

/**
 *  e支付从手机银行回跳商户App
 *
 *  @param url         支付完成，手机银行跳回商户App时回调的URL信息
 */
- (void)ICBCResultBackWithUrl: (NSURL *)url;

/**
 *  支付宝回跳商户App
 *
 *  @param url         支付完成，支付宝跳回商户App时回调的URL信息
 */
- (void)aliPayResultBackWithUrl: (NSURL *)url;

/**
 *  获取支付SDK的版本号
 *
 */
- (NSString *)getVersion;


/** 测试环境，请配置 urlListmain 和 urlPortal */
@property (nonatomic, strong) NSString *urlListMain; //支付平台地址
@property (nonatomic, strong) NSString *urlPortal; //手机银行地址

@end


