//
//  HQLPasswordViewController.m
//  MYDropMenu_Example
//
//  Created by ToninTech on 2017/7/19.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "HQLPasswordViewController.h"
#import "HQLPasswordsView.h"

@interface HQLPasswordViewController ()

@property (nonatomic, strong) HQLPasswordsView *passwordsView;

@end

@implementation HQLPasswordViewController

#pragma mark - Lifecycle

- (void)loadView {
    self.view = self.passwordsView;
    self.passwordsView.forgetPasswordBlock = ^{
        NSLog(@"忘记密码怎么办");
    };
    self.passwordsView.closeBlock = ^{
        NSLog(@"关闭密码输入框，取消支付怎么办");
    };
    __weak __typeof(self)weakSelf = self;
    self.passwordsView.finishBlock = ^(NSString *password) {
        NSLog(@"password:%@",password);
        // 
        [weakSelf.passwordsView requestComplete:NO
                                        message:@"支付失败"];
        
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.passwordsView.pwdTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (HQLPasswordsView *)passwordsView {
    if (!_passwordsView) {
        _passwordsView = [[HQLPasswordsView alloc] init];
        _passwordsView.title = @"输入社保卡密码";
        _passwordsView.loadingText = @"验证社保卡密码...";
    }
    return _passwordsView;
}

@end
