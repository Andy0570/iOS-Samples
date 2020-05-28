//
//  HQLBrandModel.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/5/27.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLBrandModel.h"

@implementation HQLBrandModel

#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name"    : @"name",
        @"logoUrl" : @"logoUrl",
    };
}

// logoUrl
// MARK: JSON String <——> NSURL
+ (NSValueTransformer *)logoUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
