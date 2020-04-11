//
//  DZFPOrderTableViewCell.m
//  ElectronicInvoiceDemo
//
//  Created by Qilin Hu on 2018/4/4.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "DZFPOrderTableViewCell.h"

// Model
#import "DZFPOrderModel.h"

// UITableViewCell 的高度
const CGFloat DZFPOrderTableViewCellHeight = 90;

@interface DZFPOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCollectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@end

@implementation DZFPOrderTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];

//    [self renderData];
}

#pragma mark - Custom Accessors

- (void)setOrderModel:(DZFPOrderModel *)orderModel {
    _orderModel = orderModel;
    
    // 设置订单模型的同时，填充数据
    [self renderData];
}

#pragma mark - Private

// 根据模型填充数据
- (void)renderData {
    
    // ------ 订单序号
    self.serialNumberLabel.text = self.orderModel.serialNumber;
    
    // ------ 订单号
    self.orderNumberLabel.text = self.orderModel.orderNumber;
    
    // ------ 订单时间
    self.orderTimeLabel.text = [self.orderModel.orderTime stringWithISOFormat];
    
    // ------ 订单收款人
    // 设置 attributedText
    NSString *orderCollectorString = [NSString stringWithFormat:@"收款人：%@",self.orderModel.orderCollector];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:orderCollectorString];
    NSDictionary *attributes1 = @{
                                  NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                  };
    [attributedString setAttributes:attributes1 range:NSMakeRange(0, 4)];
    self.orderCollectorLabel.attributedText = attributedString;
    
    // ------ 订单金额
    NSString *orderAmountString = [NSString stringWithFormat:@"金额：%@",self.orderModel.orderAmount];
    NSUInteger length = orderAmountString.length;
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:orderAmountString];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSDictionary *attributes21 = @{
                                  NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                  NSFontAttributeName:font
                                  };
    [attributedString2 setAttributes:attributes21 range:NSMakeRange(0, 3)];

    NSDictionary *attributes22 = @{
                                  NSForegroundColorAttributeName:HexColor(@"#FF4359"),
                                  NSFontAttributeName:font
                                  };
    [attributedString2 setAttributes:attributes22 range:NSMakeRange(3, length-3)];
    self.orderAmountLabel.attributedText = attributedString2;
    
    // ------ 订单状态
    [self renderOrderStateLabel];
    
}


- (void)renderOrderStateLabel {
    
    switch (self.orderModel.orderState) {
        case DZFPOrderModelOrderStateSuccess: {
            self.orderStateLabel.text = @"订单成功";
            self.orderStateLabel.layer.backgroundColor = rgb(76, 217, 100).CGColor;
            self.orderStateLabel.layer.cornerRadius = 3; // 设置圆角
            break;
        }
        case DZFPOrderModelOrderStateFailure: {
            self.orderStateLabel.text = @"订单失败";
            self.orderStateLabel.layer.backgroundColor = rgb(255, 59, 48).CGColor;
            self.orderStateLabel.layer.cornerRadius = 3; // 设置圆角
            break;
        }
        case DZFPOrderModelOrderStateUnkonw: {
            self.orderStateLabel.text = @"订单异常";
            self.orderStateLabel.layer.backgroundColor = rgb(255, 204, 0).CGColor;
            self.orderStateLabel.layer.cornerRadius = 3; // 设置圆角
            break;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
