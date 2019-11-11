//
//  LoginState.h
//  PassValueDemo
//
//  Created by ToninTech on 2017/3/15.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginState : NSObject

@property (nonatomic, assign) BOOL loginFlag;

+ (instancetype)sharedLoginState;

@end
