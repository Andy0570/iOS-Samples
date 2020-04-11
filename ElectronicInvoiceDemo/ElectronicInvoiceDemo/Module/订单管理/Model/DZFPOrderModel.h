//
//  DZFPOrderModel.h
//  ElectronicInvoiceDemo
//
//  Created by Qilin Hu on 2018/4/4.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 使用枚举类型表示订单状态
typedef NS_ENUM(NSUInteger, DZFPOrderModelOrderState) {
    DZFPOrderModelOrderStateSuccess, // 订单收据上传成功
    DZFPOrderModelOrderStateFailure, // 订单收据上传失败
    DZFPOrderModelOrderStateUnkonw,  // 未知错误
};

/**
 电子发票订单模型
 */
@interface DZFPOrderModel : NSObject

@property (nonatomic, copy, readonly) NSString *serialNumber; // 序号
@property (nonatomic, copy, readonly) NSString *orderNumber;  // 订单号
@property (nonatomic, copy, readonly) NSDate *orderTime;      // 订单时间
@property (nonatomic, copy, readonly) NSString *orderAmount;  // 订单金额
@property (nonatomic, copy, readonly) NSString *orderCollector; // 订单收款人
@property (nonatomic, assign, readonly) DZFPOrderModelOrderState orderState; // 订单状态

@end
