//
//  HQLBanner.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBanner.h"

@implementation HQLBanner

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name"     : @"name",
        @"imageURL" : @"pic",
        @"linkURL"  : @"url",
        @"note"     : @"note"
    };
}

// imageURL
// MARK: JSON String <——> NSURL
+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// linkURL
// MARK: JSON String <——> NSURL
+ (NSValueTransformer *)linkURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
