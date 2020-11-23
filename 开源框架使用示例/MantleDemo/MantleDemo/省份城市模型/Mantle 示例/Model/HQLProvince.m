//
//  HQLProvince.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/7/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLProvince.h"
#import "HQLCity.h"

@implementation HQLProvince

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"code"     : @"code",
        @"name"     : @"name",
        @"children" : @"children"
    };
}

// children
// MARK: JSON Array <——> NSArray<Model>
+ (NSValueTransformer *)childrenJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:HQLCity.class];
}

@end
