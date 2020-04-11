//
//  DZFPOrderTableViewCell.h
//  ElectronicInvoiceDemo
//
//  Created by Qilin Hu on 2018/4/4.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZFPOrderModel; // 电子发票订单模型

// UITableViewCell 的高度，具体高度值在 .m 中声明
UIKIT_EXTERN const CGFloat DZFPOrderTableViewCellHeight;

/**
 订单管理-订单cell
 */
@interface DZFPOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) DZFPOrderModel *orderModel;

@end
