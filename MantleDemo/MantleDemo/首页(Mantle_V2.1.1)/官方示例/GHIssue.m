//
//  GHIssue.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "GHIssue.h"
#import "GHUser.h"


@implementation GHIssue

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;

    // 存储需要在初始化时由本地确定的值
    _retrievedAt = [NSDate date];

    return self;
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

// 模型和 JSON 的自定义映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"URL"           : @"url",
        @"HTMLURL"       : @"html_url",
        @"number"        : @"number",
        @"state"         : @"state",
        @"reporterLogin" : @"user.login",
        @"assignee"      : @"assignee",
        @"updatedAt"     : @"updated_at"
    };
}

// 自定义 JSON 模型转换，URL -> NSURL
+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// 自定义 JSON 模型转换，URL -> NSURL
+ (NSValueTransformer *)HTMLURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// 自定义 JSON 模型转换，JSON 字符串 -> 枚举类型 进行映射
+ (NSValueTransformer *)stateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"open": @(GHIssueStateOpen),
        @"closed": @(GHIssueStateClosed)
    }];
}

// assignee 属性是一个 GHUser 对象实例
+ (NSValueTransformer *)assigneeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:GHUser.class];
}

// 自定义 JSON 模型转换，JSON 字符串 -> NSDate
+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
