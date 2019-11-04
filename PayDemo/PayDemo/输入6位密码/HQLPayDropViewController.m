//
//  HQLPayDropViewController.m
//  PayDemo
//
//  Created by Qilin Hu on 2019/9/9.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import "HQLPayDropViewController.h"

// Frameworks
#import <YYKit/YYKit.h>
#import <UIAlertController+Blocks.h>

// Views
#import "HQLPasswordView/HQLPasswordsView.h"

const CGFloat HQLPayDropViewControllerHeight = 441;

@interface HQLPayDropViewController ()

@property (nonatomic, strong) HQLPasswordsView *passwordsView;

@end

@implementation HQLPayDropViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
}

#pragma mark - Custom Accessors

- (HQLPasswordsView *)passwordsView {
    if (!_passwordsView) {
        _passwordsView = [[HQLPasswordsView alloc] init];
        _passwordsView.title = @"输入支付密码";
        _passwordsView.loadingText = @"正在验证密码...";
        _passwordsView.closeButtonImage = @"password_close";
    }
    return _passwordsView;
}

#pragma mark - IBActions

#pragma mark - Public

#pragma mark - Private

- (void)addSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self passwordsBlockHandle];
    [self.view addSubview:self.passwordsView];
    
    self.passwordsView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, HQLPayDropViewControllerHeight);
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.passwordsView.frame = CGRectMake(0, 0, kScreenWidth, HQLPayDropViewControllerHeight);
                     } completion:^(BOOL finished) {
                         [self.passwordsView.pwdTextField becomeFirstResponder];
                     }];
}

- (void)passwordsBlockHandle {
    __weak __typeof(self)weakSelf = self;
    
    // -------- 关闭按钮
    self.passwordsView.closeBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    // -------- 忘记密码按钮
    self.passwordsView.forgetPasswordBlock = ^{
        [UIAlertController showAlertInViewController:weakSelf
                                           withTitle:@"温馨提示"
                                             message:@"忘记密码功能暂未开发，敬请期待！"
                                   cancelButtonTitle:@"确定"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:nil
                                            tapBlock:nil];
    };
    
    // ------ 完成按钮
    self.passwordsView.finishBlock = ^(NSString *password) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            
            // 发送密码，模拟网络请求
            double delayInSeconds = 5.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                    delayInSeconds *NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                
                // 支付成功
                [strongSelf.passwordsView requestComplete:YES message:@"支付成功"];
                
                // 延迟 2 秒执行
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    
                    [strongSelf dismissViewControllerAnimated:YES completion:^{
                        // 处理回调...
                        // Flag: 12345
                    }];
                    
                });
            });

            
        }
    };
}

@end
