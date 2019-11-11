//
//  SuccessLoginDelegate.h
//  PassValueDemo
//
//  Created by ToninTech on 2017/3/15.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 枚举类型，需要登录的功能标记位
 
 - functionPageNameA: 功能A
 - functionPageNameB: 功能B
 */
typedef NS_ENUM(char,functionPageName ){
    functionPageNameA = 1,
    functionPageNameB = 2,
};

@protocol SuccessLoginDelegate <NSObject>

-(void)returnToViewController:(functionPageName )pageName;

@end
