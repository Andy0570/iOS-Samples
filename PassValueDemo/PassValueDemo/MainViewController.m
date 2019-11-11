//
//  MainViewController.m
//  PassValueDemo
//
//  Created by ToninTech on 2017/3/15.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "MainViewController.h"
#import "LoginState.h"
#import "SuccessLoginDelegate.h"
#import "LoginViewController.h"
#import "FirstFunctionViewController.h"
#import "SecondFunctionViewController.h"

@interface MainViewController () <SuccessLoginDelegate>

@property (nonatomic, strong) LoginState *loginState;

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
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

- (IBAction)buttonA_Click:(id)sender {
    BOOL isLogin = self.loginState.loginFlag;
    if (isLogin) {
        [self showFirstFunctionViewControllerWithAnimation:YES];
    }else {
        [self showLoginViewControllerWithIndex:1];
    }
}

- (IBAction)buttonB_Click:(id)sender {
    BOOL isLogin = self.loginState.loginFlag;
    if (isLogin) {
        [self showSecondFunctionViewControllerWithAnimation:YES];
    }else {
        [self showLoginViewControllerWithIndex:2];
    }
    
}


#pragma mark - Private

// 进入功能A
- (void)showFirstFunctionViewControllerWithAnimation:(BOOL)animated {
    FirstFunctionViewController *firstViewController = [[FirstFunctionViewController alloc] init];
    firstViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:firstViewController animated:animated];
}

// 进入功能B
- (void)showSecondFunctionViewControllerWithAnimation:(BOOL)animated {
    SecondFunctionViewController *secondViewController = [[SecondFunctionViewController alloc] init];
    secondViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:secondViewController animated:animated];
}

// 打开登录页面
- (void)showLoginViewControllerWithIndex:(NSInteger)index {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    LoginViewController *loginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"loginPage"];
    loginViewController.hidesBottomBarWhenPushed = YES;
    loginViewController.index = index;
    loginViewController.delegate = self;
    [self.navigationController pushViewController:loginViewController animated:YES];
}


#pragma mark - SuccessLoginDelegate

-(void)returnToViewController:(functionPageName )pageName {
    switch (pageName) {
        case functionPageNameA:
            [self showFirstFunctionViewControllerWithAnimation:NO];
            break;
        case functionPageNameB:
            [self showSecondFunctionViewControllerWithAnimation:NO];
            break;
        default:
            break;
    }
}

@end
