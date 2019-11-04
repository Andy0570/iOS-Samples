//
//  HQLCrayonShinChanViewController.m
//  PayDemo
//
//  Created by Qilin Hu on 2019/9/9.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import "HQLCrayonShinChanViewController.h"

// 第三方框架
#import <Chameleon.h>
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

// Controller
#import "HQLPayDropViewController.h"

@interface HQLCrayonShinChanViewController ()

// 支付按钮
@property (nonatomic, strong) UIButton *paymentButton;

@end

@implementation HQLCrayonShinChanViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单结算页面";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加支付按钮
    [self.view addSubview:self.paymentButton];
    [self.paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.height.mas_equalTo(52);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-64);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view).with.offset(-64);
        }
    }];
}

#pragma mark - Custom Accessors

- (UIButton *)paymentButton {
    if (!_paymentButton) {
        _paymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _paymentButton.layer.cornerRadius = 5.f;
        _paymentButton.layer.masksToBounds = YES;
        // 标题
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:18],
                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"支付"
                                                                    attributes:attributes];
        [_paymentButton setAttributedTitle:title forState:UIControlStateNormal];
        // 背景颜色
        [_paymentButton setBackgroundImage:[UIImage imageWithColor:HexColor(@"#108EE9")]
                                  forState:UIControlStateNormal];
        [_paymentButton setBackgroundImage:[UIImage imageWithColor:HexColor(@"#1284D6")]
                                forState:UIControlStateHighlighted];
        [_paymentButton addTarget:self
                           action:@selector(paymentButtionDidClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentButton;
}


#pragma mark - IBActions

- (void)paymentButtionDidClicked:(id)sender {
    
    // 输入支付密码
    CGRect rect = CGRectMake(0, kScreenHeight - HQLPayDropViewControllerHeight, kScreenWidth, HQLPayDropViewControllerHeight);
    HQLPayDropViewController *payDropViewController = [[HQLPayDropViewController alloc] initWithShowFrame:rect ShowStyle:MYPresentedViewShowStyleFromBottomDropStyle callback:^(id callback) {
        // 支付成功后接收到的回调处理
        // Flag: 12345
    }];
    [self presentViewController:payDropViewController animated:YES completion:nil];
}

@end
