//
//  HQLContact.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/29.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLContact.h"

@implementation HQLContact

// 构造方法
- (HQLContact *)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastname
                      phoneNumber:(NSString *)phoneNumber {
    if (self) {
        self = [super init];
        _firstName = firstName;
        _lastName = lastname;
        _phoneNumber = phoneNumber;
    }
    return self;
}

// 静态初始化方法
+ (HQLContact *)initWithFirstName:(NSString *)firstName
                         lastName:(NSString *)lastName
                      phoneNumber:(NSString *)phoneNumber {
    HQLContact *contact1 = [[HQLContact alloc] initWithFirstName:firstName lastName:lastName phoneNumber:phoneNumber];
    return contact1;
}

// get姓名
- (NSString *)geTName {
    return [NSString stringWithFormat:@"%@%@",_lastName,_firstName];
}

@end
