//
//  HQLPayResultModel.h
//  Demo
//
//  Created by Qilin Hu on 2020/5/22.
//  Copyright © Qilin Hu. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

// 支付方式
typedef NS_ENUM(NSUInteger, HQLPaymentType) {
    HQLPaymentTypeWechat, // 微信支付
    HQLPaymentTypeAlipay, // 支付宝支付
};

typedef NS_ENUM(NSUInteger, HQLPaymentState) {
    HQLPaymentStateSuccess, // 支付成功
    HQLPaymentStateFailure, // 支付失败
    HQLPaymentStateWatting, // 等待支付
    HQLPaymentStateUnknow,  // 未知异常
};

@interface HQLPayResultModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, assign) HQLPaymentType paymentType;
@property (nonatomic, readonly, assign) HQLPaymentState paymentState;
@property (nonatomic, readonly, strong) NSNumber *payAmount; // 支付金额

- (instancetype)initWithPaymentType:(HQLPaymentType)paymentType
                       paymentState:(HQLPaymentState)paymentState
                          payAmount:(NSNumber *)amount;

@end

NS_ASSUME_NONNULL_END
