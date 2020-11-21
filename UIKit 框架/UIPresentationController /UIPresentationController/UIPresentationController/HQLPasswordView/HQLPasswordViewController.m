//
//  HQLPasswordViewController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLPasswordViewController.h"
#import "HQLPasswordsView.h"

@interface HQLPasswordViewController ()
@property (nonatomic, strong) HQLPasswordsView *passwordView;
@end

@implementation HQLPasswordViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.passwordView];
    [self configurePasswordView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 自动弹出键盘
    [self.passwordView.pwdTextField becomeFirstResponder];
}

#pragma mark - Custom Accessors

- (HQLPasswordsView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[HQLPasswordsView alloc] initWithFrame:self.view.bounds];
    }
    return _passwordView;
}


#pragma mark - Private

- (void)configurePasswordView {
    __weak __typeof(self)weakSelf = self;
    
    // MARK: 关闭按钮
    self.passwordView.closeBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
    };

    // MARK: 忘记密码
    self.passwordView.forgetPasswordBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
        
        // 执行找回密码流程
    };
    
    // MARK: 输入所有密码，发起网络请求，校验密码
    self.passwordView.finishBlock = ^(NSString *inputPassword) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSLog(@"password = %@",inputPassword);
        
        // 通过 GCD 模拟网络请求
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                delayInSeconds *NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [strongSelf.passwordView requestComplete:YES message:@"支付成功"];
        });
    };
}

@end
