//
//  HQLContact.h
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/29.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 联系人模型
@interface HQLContact : NSObject

@property (nonatomic,copy) NSString *firstName;
@property (nonatomic,copy) NSString *lastName;
@property (nonatomic,copy) NSString *phoneNumber;

// 静态初始化方法
+ (HQLContact *)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                      phoneNumber:(NSString *)phoneNumber;

// 构造方法
- (HQLContact *)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastname
                      phoneNumber:(NSString *)phoneNumber;

- (NSString *)getFullName;

@end
