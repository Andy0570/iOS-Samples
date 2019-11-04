 //
//  HQLScaryBugData.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HQLScaryBugData.h"
#import <YYKit.h>

#define KTitleKey  @"Title"
#define KRatingKey @"Rating"

@implementation HQLScaryBugData

#pragma mark - Lifecycle

- (instancetype)initWithTitle:(NSString *)title rating:(float)rating {
    self = [super init];
    if (self) {
        _title  = [title copy];
        _rating = rating;
    }
    return self;
}

#pragma mark - NSCoding

// #2 实现 NSCoding 编码方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:KTitleKey];
    [aCoder encodeFloat:_rating forKey:KRatingKey];
}

// #3 实现 NSCoding 解码方法
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    NSString *title = [aDecoder decodeObjectForKey:KTitleKey];
    float rating = [aDecoder decodeFloatForKey:KRatingKey];
    return [self initWithTitle:title rating:rating];
}

//// #4 使用 NSObject+YYAdd 中的便捷语法
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [self modelEncodeWithCoder:aCoder];
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    return [self modelInitWithCoder:aDecoder];
//}

@end
