//
//  HQLCategory.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCategory.h"
#import <YYKit.h>
#import <JKCategories.h>

@implementation HQLCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"ID"       : @"id",
        @"parentId" : @"parentId",
        @"name"     : @"name",
        @"iconURL"  : @"icon"
    };
}

// iconURL
// JSON String —> NSURL
+ (NSValueTransformer *)iconURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *formattedStr = [value jk_stringByEscapingForAsciiHTML];
            return [formattedStr isNotBlank] ? [NSURL URLWithString:formattedStr] : nil;
        } else if ([value isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)value;
            return [url.absoluteString jk_isValidUrl] ? url : nil;
        } else {
            return nil;
        }
    }];
}

@end
