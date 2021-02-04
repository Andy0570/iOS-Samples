//
//  UIViewController+Extension.m
//  XuZhouSS
//
//  Created by Qilin Hu on 2017/6/22.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)


#pragma mark - IBActions

- (void)backToRootViewController:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Public

// 设置导航栏返回按钮
- (void)setNavigationBarBackButton {
    UIBarButtonItem *backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
}

// 设置导航栏返回按钮+关闭按钮
- (void)setNavigationBarBackButtonAndCloseButton {
    [self setNavigationBarBackButton];
    // 设置导航栏其他按钮：关闭
    UIBarButtonItem *closeBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(backToRootViewController:)];
    self.navigationItem.leftBarButtonItem = closeBarButtonItem;
    // 设置左侧自定义按钮是否与返回按钮共同存在
    self.navigationItem.leftItemsSupplementBackButton = YES;
}


@end
