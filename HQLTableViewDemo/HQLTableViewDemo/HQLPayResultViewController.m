//
//  HQLPayResultViewController.m
//  Demo
//
//  Created by Qilin Hu on 2020/5/22.
//  Copyright © Qilin Hu. All rights reserved.
//

#import "HQLPayResultViewController.h"

@interface HQLPayResultViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *paymentTypeLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *paymentStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;

@property (nonatomic, strong) HQLPayResultModel *resultModel;


@end

@implementation HQLPayResultViewController


#pragma mark - Controller life cycle

- (instancetype)initWithPayResult:(HQLPayResultModel *)resultModel {
    self = [super init];
    if (self) {
        _resultModel = resultModel;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Method Undefined"
                                   reason:@"Use Designated Initializer Method"
                                 userInfo:nil];
    return nil;
}


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)renderUI {
    // 支付方式图片
    
    // 支付方式
    switch (self.resultModel.paymentType) {
        case HQLPaymentTypeWechat: {
            UIImage *wechatLogoImg = [UIImage imageNamed:@"wechat_round_large"];
            self.paymentTypeLogoImageView.image = wechatLogoImg;
            self.paymentTypeLabel.text = @"微信";
            break;
        }
        case HQLPaymentTypeAlipay: {
            UIImage *alipayLogoImg = [UIImage imageNamed:@"alipay_round_large"];
            self.paymentTypeLogoImageView.image = alipayLogoImg;
            self.paymentTypeLabel.text = @"支付宝";
            break;
        }
    }
    
    // 支付结果
    switch (self.resultModel.paymentState) {
        case HQLPaymentStateSuccess: {
            self.paymentStateLabel.text = @"支付成功";
            break;
        }
        case HQLPaymentStateFailure: {
            self.paymentStateLabel.text = @"支付失败";
            break;
        }
        case HQLPaymentStateWatting: {
            self.paymentStateLabel.text = @"等待支付完成";
            break;
        }
        case HQLPaymentStateUnknow: {
            self.paymentStateLabel.text = @"支付异常";
            break;
        }
    }
    
    // 支付金额（效果：¥ 18 号字体，价格 28 号字体）
    NSString *amountStr = [NSString stringWithFormat:@"¥ %.2f", [self.resultModel.payAmount floatValue]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:amountStr];
    NSDictionary *attributes1 = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]
    };
    [attributedString setAttributes:attributes1 range:NSMakeRange(0, 1)];

    NSDictionary *attributes2 = @{
        NSFontAttributeName:[UIFont systemFontOfSize:28 weight:UIFontWeightMedium]
    };
    [attributedString setAttributes:attributes2 range:NSMakeRange(2, amountStr.length-2)];
    self.payAmountLabel.attributedText = attributedString;
}


#pragma mark - Actions

// 完成按钮点击，返回到主页
- (IBAction)finishButtonDidClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
