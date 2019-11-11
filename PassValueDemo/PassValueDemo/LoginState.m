//
//  LoginState.m
//  PassValueDemo
//
//  Created by ToninTech on 2017/3/15.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "LoginState.h"

@implementation LoginState

+ (instancetype)sharedLoginState {
    static LoginState *loginState;
    if (!loginState) {
        loginState = [[LoginState alloc] init];
        loginState.loginFlag = NO;
    }
    return loginState;
}

@end
