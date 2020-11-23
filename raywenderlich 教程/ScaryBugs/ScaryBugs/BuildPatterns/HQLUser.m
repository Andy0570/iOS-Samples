//
//  HQLUser.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2018/1/9.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "HQLUser.h"

@interface HQLUser ()

// 在内部将属性重新封装为 readwrite，这样属性在内部就是可读可写的。
@property (nonatomic, copy, readwrite) NSString *userID;
@property (nonatomic, copy, readwrite) NSString *firstName;
@property (nonatomic, copy, readwrite) NSString *lastName;
@property (nonatomic, copy, readwrite) NSString *gender;
@property (nonatomic, copy, readwrite) NSDate *dateOfBirth;
@property (nonatomic, copy, readwrite) NSArray *albums;

@end

@implementation HQLUser

- (instancetype)initWithUserID:(NSString *)userID
                     firstName:(NSString *)firstName
                      lastName:(NSString *)lastName
                        gender:(NSString *)gender
                   dateOfBirth:(NSDate *)dateOfBirth
                        albums:(NSArray *)albums {
    if (self = [super init]) {
        _userID      = [userID copy];
        _firstName   = [firstName copy];
        _lastName    = [lastName copy];
        _gender      = [gender copy];
        _dateOfBirth = dateOfBirth;
        _albums      = [albums copy];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Method Undefined"
                                   reason:@"Use Designated Initializer Method"
                                 userInfo:nil];
    return nil;
}

@end
