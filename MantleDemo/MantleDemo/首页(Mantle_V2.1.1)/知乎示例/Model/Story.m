//
//  Story.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "Story.h"

@implementation Story

#pragma mark - MTLJSONSerializing

// 模型和 JSON 的自定义映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"imageHue" : @"image_hue",
        @"title"    : @"title",
        @"url"      : @"url",
        @"hint"     : @"hint",
        @"gaPrefix" : @"ga_prefix",
        @"images"   : @"images",
        @"type"     : @"type",
        @"storyID"  : @"id",
        @"testString" : @"testString"
    };
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

//// images 数组中存放的是 NSURL 对象
//+ (NSValueTransformer *)imagesJSONTransformer {
//    return [MTLJSONAdapter arrayTransformerWithModelClass:NSString.class];
//}

//+ (NSValueTransformer *)storyIDJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        return [NSString stringWithFormat:@"%@",value];
//    }];
//}
//
//+ (NSValueTransformer *)typeJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        return [NSString stringWithFormat:@"%@",value];
//    }];
//}

@end
