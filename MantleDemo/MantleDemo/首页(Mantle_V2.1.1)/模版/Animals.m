//
//  Animals.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "Animals.h"
#import "Dog.h"

@implementation Animals


#pragma mark - Initialize

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;

    _notes = @"我是一个自定义初始值";

    return self;
}

// 设置字符串的日期格式
+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setDateFormat:@"yyyy-M-d HH:mm:ss"];
    return dateFormatter;
}


#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name"        : @"dogs.animal_name",
        @"typeID"      : @"id",
        @"date"        : @"updated_time",
        @"url"         : @"url",
        @"imagesArray" : @"images",
        @"dogsArray"   : @"dogs",
        @"state"       : @"state",
        @"dog"         : @"dog"
    };
}

// MARK: JSON String <——> NSString
+ (NSValueTransformer *)nameJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}

// MARK: JSON String <——> NSDate
+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

// MARK: JSON String <——> NSURL
+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// MARK: JSON Array <——> NSArray<Model>
+ (NSValueTransformer *)storiesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:Dog.class];
}

// MARK: JSON String <——> 枚举类型
+ (NSValueTransformer *)stateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"a": @(AnimalStateA),
        @"b": @(AnimalStateB),
        @"c": @(AnimalStateC)
    }];
}

// MARK: JSON Object <——> 对象类型
+ (NSValueTransformer *)assigneeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:Dog.class];
}

// MARK: 自定义 JSON 模型转换，方法二
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"name"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            return [NSString stringWithFormat:@"%@",value];
        }];
    } else if ([key isEqualToString:@"date"]) {
        return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
            return [self.dateFormatter dateFromString:dateString];
        } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [self.dateFormatter stringFromDate:date];
        }];
    } else if ([key isEqualToString:@"url"]) {
         return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
    } else if ([key isEqualToString:@"stories"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:Dog.class];
    }
    
    return nil;
}

@end
