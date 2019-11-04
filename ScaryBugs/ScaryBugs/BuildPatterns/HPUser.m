//
//  HPUser.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2018/1/9.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "HPUser.h"

@implementation HPUserBuilder

- (HPUser *)build {
    return [[HPUser alloc] initWithBuilder:self];
}

- (HPUserBuilder *)username:(NSString *)username {
    _username = [username copy];
    return self;
}

- (HPUserBuilder *)gender:(NSString *)gender {
    _gender = [gender copy];
    return self;
}

- (HPUserBuilder *)dateOfBirth:(NSDate *)dateOfBirth {
    _dateOfBirth = dateOfBirth;
    return self;
}

@end

@implementation HPUser

- (instancetype)initWithBuilder:(HPUserBuilder *)builder {
    if (self = [super init]) {
        _username = builder.username;
        _gender = builder.gender;
        _dateOfBirth = builder.dateOfBirth;
    }
    return self;
}

- (instancetype)initWithBlock:(HPUserBuilderBlock)block {
    HPUserBuilder *builder = [[HPUserBuilder alloc] init];
    block(builder);
    return [builder build];
}

@end
