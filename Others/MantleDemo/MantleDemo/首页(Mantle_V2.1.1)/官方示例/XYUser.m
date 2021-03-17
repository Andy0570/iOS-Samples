//
//  XYUser.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/5/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "XYUser.h"

@implementation XYHelper

+ (instancetype)helperWithName:(NSString *)name createdAt:(NSDate *)createdAt {
    XYHelper *helper = [[XYHelper alloc] initWithDictionary:nil error:nil];
    helper.name = [name copy];
    helper.createdAt = createdAt;
    return helper;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;

    return self;
}

// 模型和 JSON 的自定义映射
// 将模型对象的属性名称与 JSON 对象的 key 名称进行映射。
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name"      : @"name",
        @"createdAt" : @"created_at"
    };
}

@end

@implementation XYUser

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    // ISO8601 格式："YYYY-MM-dd'T'HH:mm:ssZ" -> "1965-07-31T00:00:00+0000"
    // dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'"; //
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    return dateFormatter;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;

    _helper = [XYHelper helperWithName:self.name createdAt:self.createdAt];

    return self;
}

// 模型和 JSON 的自定义映射
// 将模型对象的属性名称与 JSON 对象的 key 名称进行映射。
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name"      : @"name",
        @"createdAt" : @"created_at"
    };
}

// createdAt
// MARK: JSON String <——> NSDate
+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}



@end
