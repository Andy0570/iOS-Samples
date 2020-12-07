//
//  HQLMarketCollectionMenuModel.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMarketCollectionMenuModel.h"

@implementation HQLMarketCollectionMenuModel

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"title" : @"title",
        @"image" : @"image"
    };
}

@end
