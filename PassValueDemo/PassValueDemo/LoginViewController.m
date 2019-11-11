//
//  LoginViewController.m
//  PassValueDemo
//
//  Created by ToninTech on 2017/3/15.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginState.h"

#define backgroundColor  [UIColor colorWithRed:141/255.0f green:218/255.0f blue:247/255.0f alpha:1.0]

@interface LoginViewController ()

@property (nonatomic,strong) LoginState *loginState;

@end

@implementation LoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:backgroundColor];
    self.navigationItem.title = @"登录";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Accessors

- (LoginState *)loginState {
    if (!_loginState) {
        _loginState = [LoginState sharedLoginState];
    }
    return _loginState;
}


#pragma mark - IBAction

- (IBAction)loginButton_Click:(id)sender {
    
    self.loginState.loginFlag = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate returnToViewController:_index];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil ];
}

- (IBAction)signOutButton_Click:(id)sender {
    
    self.loginState.loginFlag = NO;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil ];
}


@end
