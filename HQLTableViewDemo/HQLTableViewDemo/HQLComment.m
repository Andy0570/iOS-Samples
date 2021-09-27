//
//  HQLComment.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLComment.h"
#import <NSObject+YYModel.h>

@implementation HQLComment

- (instancetype)init {
    self = [super init];
    if (self) {
        _mediabaseId = @89757;
    }
    return self;
}

#pragma mark - Description

- (NSString *)description {
    return [self modelDescription];
}

@end
