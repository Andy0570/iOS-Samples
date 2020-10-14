//
//  HQLUser.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLUser.h"
#import <YYKit/NSObject+YYModel.h>

@interface HQLUser ()

@property (nonatomic, readwrite, strong) NSNumber *userId;
@property (nonatomic, readwrite, copy) NSString *nickname;
@property (nonatomic, readwrite, strong) NSURL *avatarUrl;

@end

@implementation HQLUser

#pragma mark - Initialize

- (instancetype)initWithUserId:(NSNumber *)userId nickname:(NSString *)nickname avatarUrl:(NSURL *)avatarUrl {
    self = [super init];
    if (self) {
        _userId = userId;
        _nickname = [nickname copy];
        _avatarUrl = avatarUrl;
    }
    return self;
}

#pragma mark - Description

- (NSString *)description {
    return [self modelDescription];
}

@end
