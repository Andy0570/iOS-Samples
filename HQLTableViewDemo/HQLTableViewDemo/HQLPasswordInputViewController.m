//
//  HQLPasswordInputViewController.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/3/6.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLPasswordInputViewController.h"
#import "HQLPasswordInputView.h"

@interface HQLPasswordInputViewController ()

@end

@implementation HQLPasswordInputViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    HQLPasswordInputView *passwordInputView = [[HQLPasswordInputView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 60)];
    passwordInputView.returnPasswordStringBlock = ^(NSString *password) {
        NSLog(@"%@",password);
    };
    [self.view addSubview:passwordInputView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private



@end
