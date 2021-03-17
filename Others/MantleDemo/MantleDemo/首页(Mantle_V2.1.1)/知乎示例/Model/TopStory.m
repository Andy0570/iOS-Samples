//
//  TopStory.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "TopStory.h"

@implementation TopStory

#pragma mark - MTLJSONSerializing

// 模型和 JSON 的自定义映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"imageHue"   : @"image_hue",
        @"hint"       : @"hint",
        @"url"        : @"url",
        @"imageURL"   : @"image",
        @"title"      : @"title",
        @"gaPrefix"   : @"ga_prefix",
        @"type"       : @"type",
        @"topStoryID" : @"id"
    };
}

// url 链接需要自定义转换成 NSURL 对象
+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// 图片的 url 链接需要自定义转换成 NSURL 对象
+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
