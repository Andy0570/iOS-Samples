//
//  DZFPOrderModel.m
//  ElectronicInvoiceDemo
//
//  Created by Qilin Hu on 2018/4/4.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "DZFPOrderModel.h"

@interface DZFPOrderModel ()

/**
 @property 属性说明：
.h 文件中属性声明为 readonly ，对外部声明为只读，这样外部类只能读取，无法随意修改该属性的值。
.m 文件中属性声明为 readwrite ，对内部重新声明为可读可写，
 
 原因参见《Effective Objective-C 2.0》第 18 条：尽量使用不可变对象。
 * 设计类时，应该充分运用属性（@property）来封装数据；
 * 应该尽量把对外公布出来的属性设置为只读（readonly），而且只在确有必要时才将属性对外公布；
 * 如果想修改封装在对象内部的数据，但是却不想令这些数据为外人所改动，我们可以在对象内部分类（class-continuation）中将 readonly 属性重新声明为 readwrite；
 */

@property (nonatomic, copy, readwrite) NSString *serialNumber; // 序号
@property (nonatomic, copy, readwrite) NSString *orderNumber;  // 订单号
@property (nonatomic, copy, readwrite) NSDate *orderTime;      // 订单时间
@property (nonatomic, copy, readwrite) NSString *orderAmount;  // 订单金额
@property (nonatomic, copy, readwrite) NSString *orderCollector; // 订单收款人
@property (nonatomic, assign, readwrite) DZFPOrderModelOrderState orderState; // 订单状态

@end

@implementation DZFPOrderModel

#pragma mark - NSObject

- (NSString *)description {
    return [self modelDescription];
}

@end
