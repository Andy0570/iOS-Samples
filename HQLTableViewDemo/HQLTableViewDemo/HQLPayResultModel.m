//
//  HQLPayResultModel.m
//  Demo
//
//  Created by Qilin Hu on 2020/5/22.
//  Copyright © Qilin Hu. All rights reserved.
//

#import "HQLPayResultModel.h"

@implementation HQLPayResultModel

#pragma mark - Initialize

- (instancetype)initWithPaymentType:(HQLPaymentType)paymentType
                       paymentState:(HQLPaymentState)paymentState
                          payAmount:(NSNumber *)amount {
    self = [super init];
    if (self) {
        _paymentType = paymentType;
        _paymentState = paymentState;
        _payAmount = amount;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Method Undefined"
                                   reason:@"Use Designated Initializer Method"
                                 userInfo:nil];
    return nil;
}

#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"paymentType"  : @"paymentType",
        @"paymentState" : @"paymentState",
        @"payAmount"    : @"payAmount"
    };
}

@end
