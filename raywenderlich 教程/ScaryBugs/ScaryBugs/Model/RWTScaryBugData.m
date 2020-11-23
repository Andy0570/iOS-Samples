//
//  RWTScaryBugData.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/22.
//

#import "RWTScaryBugData.h"

#define KTitleKey  @"Title"
#define KRatingKey @"Rating"

@implementation RWTScaryBugData

#pragma mark - Initialize

- (instancetype)initWithTitle:(NSString *)title rating:(float)rating {
    if (self = [super init]) {
        _title = [title copy];
        _rating = rating;
    }
    return self;
}

#pragma mark - NSSecureCoding

// 支持加密编码
+ (BOOL)supportsSecureCoding {
   return YES;
}

// #2 实现 NSCoding 编码方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:KTitleKey];
    [aCoder encodeFloat:_rating forKey:KRatingKey];
}

// #3 实现 NSCoding 解码方法
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    //NSString *title = [aDecoder decodeObjectForKey:KTitleKey];
    NSString *title = [aDecoder decodeObjectOfClass:NSString.class forKey:KTitleKey];
    float rating = [aDecoder decodeFloatForKey:KRatingKey];
    
    NSLog(@"title = %@, rating = %f",title,rating);
    return [self initWithTitle:title rating:rating];
}

// #4 使用 NSObject+YYAdd 中的便捷语法
// 需要 #import <YYKit.h>
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [self modelEncodeWithCoder:aCoder];
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    return [self modelInitWithCoder:aDecoder];
//}

@end
