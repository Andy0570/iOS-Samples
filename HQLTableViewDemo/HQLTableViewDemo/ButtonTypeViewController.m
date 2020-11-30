//
//  ButtonTypeViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "ButtonTypeViewController.h"
#import <Masonry.h>

@interface ButtonTypeViewController ()

@end

@implementation ButtonTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    // UIButtonTypeCustom
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
    [button1 setTitle:@"button1" forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(10);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
    }];

    // UIButtonTypeSystem
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"button2" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button1.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button1);
    }];
    
    // UIButtonTypeDetailDisclosure
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [self.view addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button2.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button2);
    }];

    // UIButtonTypeInfoLight
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.view addSubview:button4];
    [button4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button3.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button3);
    }];

    // UIButtonTypeInfoDark
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.view addSubview:button5];
    [button5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button4.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button4);
    }];
    
    // UIButtonTypeContactAdd
    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:button6];
    [button6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button5.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button5);
    }];
    
    // UIButtonTypeRoundedRect = UIButtonTypeSystem
    UIButton *button7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button7.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
    [button7 setTitle:@"button7" forState:UIControlStateNormal];
    [self.view addSubview:button7];
    [button7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button6.mas_bottom).with.offset(20);
        make.left.mas_equalTo(button6);
    }];
}



@end
