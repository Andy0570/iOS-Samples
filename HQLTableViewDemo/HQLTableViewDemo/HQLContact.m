//
//  HQLContact.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/29.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLContact.h"

@implementation HQLContact

// 静态初始化方法
+ (HQLContact *)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                      phoneNumber:(NSString *)phoneNumber {
    HQLContact *contact = [[HQLContact alloc] initWithFirstName:firstName lastName:lastName phoneNumber:phoneNumber];
    return contact;
}

// 构造方法
- (HQLContact *)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastname
                      phoneNumber:(NSString *)phoneNumber {
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastname;
        _phoneNumber = phoneNumber;
    }
    return self;
}

- (NSString *)getFullName {
    return [NSString stringWithFormat:@"%@%@",_lastName,_firstName];
}

@end
