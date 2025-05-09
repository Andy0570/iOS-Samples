//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.signInService = [RWDummySignInService new];

    // initially hide the failure message
    self.signInFailureText.hidden = YES;
    
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
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
        return @(usernameValid.boolValue && passwordValid.boolValue);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled = signupActive.boolValue;
    }];
    
    // 外层是一个按钮触摸事件的信号
    // 通过 flattenMap 方法将按钮触摸事件信号转换为登录事件信号
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(__kindof UIControl *_Nullable x) { // 执行副作用（可用 RACCommand 来实现）
           self.signInButton.enabled = NO;
           self.signInFailureText.hidden = YES;
       }] flattenMap:^id _Nullable (__kindof UIControl *_Nullable value) {
           // 内层创建并返回了一个登录事件信号
           return [self signInSingal];
       }] subscribeNext:^(NSNumber *signIn) {
           // 登录成功，执行页面跳转逻辑
           self.signInButton.enabled = YES;
           BOOL success = signIn.boolValue;
           self.signInFailureText.hidden = success;
           if (success) {
               [self performSegueWithIdentifier:@"signInSuccess" sender:self];
           }
       }];
}

- (RACSignal *)signInSingal {
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

@end
