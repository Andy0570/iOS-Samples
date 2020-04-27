//
//  LatestModel.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "LatestModel.h"

// Model
#import "Story.h"
#import "TopStory.h"

@implementation LatestModel

#pragma mark - MTLJSONSerializing

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return dateFormatter;
}

// 模型和 JSON 的自定义映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"date"       : @"date",
        @"stories"    : @"stories",
        @"topStories" : @"top_stories"
    };
}

// 自定义模型转换有两种方式：
// MARK: 1.各个属性单独设置，以下三个自定义 JSON 模型转换方法优先级最高
// 自定义 JSON 模型转换，JSON 字符串 -> NSDate
+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

// 自定义 JSON 模型转换
// 属性 stories 是一个数组，数组内存放的是指向 Story 实例对象的指针
+ (NSValueTransformer *)storiesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:Story.class];
}

// 属性 topStories 是一个数组，数组内存放的是指向 TopStory 实例对象的指针
+ (NSValueTransformer *)topStoriesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:TopStory.class];
}

// MARK: 2. 通过判断 key 值的不同批量设置，此方法优先级低于上述方法
//// 自定义 JSON 模型转换
//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
//    if ([key isEqualToString:@"date"]) {
//        return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
//            return [self.dateFormatter dateFromString:dateString];
//        } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
//            return [self.dateFormatter stringFromDate:date];
//        }];
//    } else if ([key isEqualToString:@"stories"]) {
//        return [MTLJSONAdapter arrayTransformerWithModelClass:Story.class];
//    } else if ([key isEqualToString:@"topStories"]) {
//        return [MTLJSONAdapter arrayTransformerWithModelClass:TopStory.class];
//    }
//    return nil;
//}


@end
