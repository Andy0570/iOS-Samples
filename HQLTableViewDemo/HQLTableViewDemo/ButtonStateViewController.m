//
//  ButtonStateViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "ButtonStateViewController.h"
#import <Masonry.h>

@interface ButtonStateViewController ()

@end

@implementation ButtonStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    // UIControlStateNormal
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"默认状态" forState:UIControlStateNormal];
    [button1 setTitle:@"高亮状态" forState:UIControlStateHighlighted];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(10);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    // UIControlStateHighlighted
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"默认状态" forState:UIControlStateNormal];
    [button2 setTitle:@"高亮状态" forState:UIControlStateHighlighted];
    [button2 setHighlighted:YES];
    [self.view addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button1.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button1);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];

    // UIControlStateDisabled
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"禁用状态" forState:UIControlStateDisabled];
    [button3 setEnabled:NO];
    [self.view addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button2.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button2);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];

    // UIControlStateSelected
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button4 setTitle:@"默认状态" forState:UIControlStateNormal];
    [button4 setTitle:@"高亮状态" forState:UIControlStateHighlighted];
    [button4 setTitle:@"选中状态" forState:UIControlStateSelected];
    [button4 setSelected:YES];
    [self.view addSubview:button4];
    [button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button3.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button3);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
}

@end
