//
//  HQLTopic.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTopic.h"
#import <CoreGraphics/CoreGraphics.h>
#import <NSObject+YYModel.h>
#import <JKCategories.h>

@implementation HQLTopic

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _mediabaseId = @89757;
    }
    return self;
}

#pragma mark - Custom Accessors

- (NSString *)thumbNumsString {
    NSString *number = NULL;
    
    if (_thumbNums.unsignedIntegerValue >= 10000) {
        CGFloat final = _thumbNums.unsignedIntegerValue / 10000.0;
        number = [NSString stringWithFormat:@"%.1f万", final];
    } else {
        number = [NSString stringWithFormat:@"%lu", (unsigned long)_thumbNums.unsignedIntegerValue];
    }
    
    return number;
}

- (NSString *)createDateTimeString {
    NSString *dateTimeString = NULL;
    
    if ([self.createDateTime jk_isThisYear]) {
        if ([self.createDateTime jk_isToday]) {
            dateTimeString = self.createDateTime.jk_timeInfo;
        } else if ([self.createDateTime jk_isYesterday]) {
            dateTimeString = [self.createDateTime jk_dateWithFormat:@"昨天 HH:mm"];
        } else {
            dateTimeString = [self.createDateTime jk_dateWithFormat:@"MM-dd HH:mm"];
        }
    } else {
        dateTimeString = [self.createDateTime jk_dateWithFormat:@"yyyy-MM-dd"];
    }
    
    return dateTimeString;
}

#pragma mark - Description

- (NSString *)description {
    return [self modelDescription];
}

@end
