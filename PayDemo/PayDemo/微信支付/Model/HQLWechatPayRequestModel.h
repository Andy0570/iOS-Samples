//
//  HQLWechatPayRequestModel.h
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/12/24.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 微信支付，服务器返回支付参数模型
 
 服务器返回 JSON 数据示例：
 {
 appid = "wx12345...678906"; （应用 ID）
 noncestr = "FS7JBpYQ5TzkyfcV"; （随机字符串）
 package = "Sign=WXPay"; （扩展字段，默认值）
 partnerid = "12345674321"; （商户号）
 prepayid = "wx2530149711249kd7b531c00a2446020522"; （预支付交易会话 ID）
 sign = "BEE9FA6FCD14D286CCCD4EE7DC74578B"; （签名）
 timestamp = 1545704053 （时间戳，精确到秒，10位！！！）
 }
 
 */
@interface HQLWechatPayRequestModel : NSObject

/** 应用 ID */
@property (nonatomic, copy, readonly) NSString *appid;
/** 商家向财付通申请的商家 ID */
@property (nonatomic, copy, readonly) NSString *partnerid;
/** 预支付订单 */
@property (nonatomic, copy, readonly) NSString *prepayid;
/** 商家根据财付通文档填写的数据和签名，默认值为 Sign=WXPay */
@property (nonatomic, copy, readonly) NSString *package;
/** 随机串，防重发 */
@property (nonatomic, copy, readonly) NSString *noncestr;
/** 时间戳，防重发 */
@property (nonatomic, assign, readonly) UInt32 timestamp;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, copy, readonly) NSString *sign;

@end

NS_ASSUME_NONNULL_END
