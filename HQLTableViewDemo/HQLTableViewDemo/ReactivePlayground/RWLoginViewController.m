//
//  RWLoginViewController.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/20.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "RWLoginViewController.h"

// Framework
#import <Masonry.h>
#import <YYKit.h>
#import <Toast.h>
#import <ReactiveObjC.h>

// Service
#import "RWDummySignInService.h"

@interface RWLoginViewController ()

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *signInButton;

@property (nonatomic, strong) RWDummySignInService *signInService;

@end

@implementation RWLoginViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"ReactiveCocoa 教程 1/2";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    [self setupBind];
}

- (void)setupSubviews {
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.signInButton];
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.leading.equalTo(self.view.mas_leading).offset(20);
        make.trailing.equalTo(self.view.mas_trailing).offset(-20);
        make.height.mas_equalTo(48);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextField.mas_bottom).offset(15);
        make.leading.trailing.equalTo(self.usernameTextField);
        make.height.mas_equalTo(48);
    }];
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(20);
        make.leading.trailing.equalTo(self.usernameTextField);
        make.height.mas_equalTo(48);
    }];
}

- (void)setupBind {
    self.signInService = [RWDummySignInService new];
    
    /**
     password
    ┌───────────────┐ NSString ┌───────┐   BOOL ┌───────┐ UIColor ┌─────────────────┐
    │rac_textSignal ├─────────►│  map  ├─┬─────►│  map  ├────────►│ backgroundColor │
    └───────────────┘          └───────┘ │      └───────┘         └─────────────────┘
                                         │
                                         │  ┌────────────────────┐ BOOL  ┌───────────────┐
                                         ├─►│combineLatest:reduce├──────►│ subscribeNext │
                                         │  └────────────────────┘       └───────────────┘
     username                            │
    ┌───────────────┐ NSString ┌───────┐ │ BOOL ┌───────┐ UIColor ┌─────────────────┐
    │rac_textSignal ├─────────►│  map  ├─┴─────►│  map  ├────────►├─backgroundColor │
    └───────────────┘          └───────┘        └───────┘         └─────────────────┘
    */
    
    RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([self isValidUsername:value]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([self isValidPassword:value]);
    }];
    
    // 通过 RAC 宏将信号的输出分配给 self.usernameTextField 对象的 backgroundColor 属性
    RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id _Nullable(NSNumber *usernameValid) {
        return usernameValid.boolValue ? UIColor.clearColor : UIColor.yellowColor;
    }];
    
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id _Nullable(NSNumber *passwordValid) {
        return passwordValid.boolValue ? UIColor.clearColor : UIColor.yellowColor;
    }];
    
    // 通过 combineLatest:reduce: 方法将多个信号合并为 1 个信号
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
        return @(usernameValid.boolValue && passwordValid.boolValue);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled = signupActive.boolValue;
    }];
    
    // 外层是一个按钮触摸事件的信号
    // 通过 flattenMap 方法将按钮触摸事件信号转换为登录事件信号
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(__kindof UIControl *_Nullable x) {
        [self.view endEditing:YES];
        self.signInButton.enabled = NO;
        // TODO: show MBProgressHUD
    }] flattenMap:^__kindof RACSignal *_Nullable (__kindof UIControl *_Nullable value) {
        // 内层创建并返回了一个登录事件信号
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *signIn) {
        self.signInButton.enabled = YES;
        // TODO: dismiss MBProgressHUD
        BOOL success = signIn.boolValue;

        if (success) {
            // 登录成功，执行页面跳转逻辑
            NSLog(@"登录成功，执行页面跳转逻辑");
        } else {
            [self.view makeToast:@"登录失败，用户名或密码错误。"];
        }
    }];
}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 发起虚拟网络请求
        [self.signInService signInWithUsername:self.usernameTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

#pragma mark - Custom Accessors

- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _usernameTextField.backgroundColor = [UIColor whiteColor];
        _usernameTextField.placeholder = [NSString stringWithFormat:@"username"];
        _usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _usernameTextField.returnKeyType = UIReturnKeyNext;
        _usernameTextField.enablesReturnKeyAutomatically = YES;
        // _usernameTextField.delegate = self;
    }
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.placeholder = [NSString stringWithFormat:@"password"];
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.enablesReturnKeyAutomatically = YES;
        _passwordTextField.secureTextEntry = YES;
        // _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

- (UIButton *)signInButton {
    if (!_signInButton) {
        _signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 设置按钮字体、颜色
        NSDictionary *normalAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17.0f],
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"Login" attributes:normalAttributes];
        [_signInButton setAttributedTitle:normalTitle forState:UIControlStateNormal];

        NSDictionary *highLightedAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
            NSForegroundColorAttributeName:UIColorHex(#47c1b6)
        };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"Login" attributes:highLightedAttributes];
        [_signInButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        
        // 按钮点击高亮效果，通过 UIColor 颜色设置背景图片
        [_signInButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(#47c1b6)]
                                 forState:UIControlStateNormal];
        [_signInButton setBackgroundImage:[UIImage imageWithColor:UIColorHex(#F5F5F9)]
                                 forState:UIControlStateHighlighted];
        
        // 设置按钮圆角
        _signInButton.layer.cornerRadius = 8.f;
        _signInButton.clipsToBounds = YES;
    }
    return _signInButton;
}

@end
