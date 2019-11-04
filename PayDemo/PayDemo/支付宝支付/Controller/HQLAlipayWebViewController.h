//
//  HQLAlipayWebViewController.h
//  PayDemo
//
//  Created by Qilin Hu on 2019/7/26.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 支付宝 H5 支付示例
 
 客户端 APP 不集成「支付宝SDK」也能发起支付宝支付。
 服务端直接返回支付 URL，客户端打开这个支付 URL 就可以向支付宝发起支付了。
 
 也可以通过集成支付宝 SDK，通过 SDK 中的方法打开这个 URL 链接：
 SDK 中，H5 支付调用接口如下：
 *  从h5链接中获取订单串并支付接口（自版本15.4.0起，推荐使用该接口）
 *
 *  @ param urlStr     拦截的 url string
 *
 *  @ return YES为成功获取订单信息并发起支付流程；NO为无法获取订单信息，输入url是普通url
 *
 - (BOOL)payInterceptorWithUrl:(NSString *)urlStr
                    fromScheme:(NSString *)schemeStr
                      callback:(CompletionBlock)completionBlock;
 */

@interface HQLAlipayWebViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
