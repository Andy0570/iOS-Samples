//
//  HQLTableViewCellGroupedModel.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright (c) 2020 独木舟的木 All rights reserved.
//

#import "HQLTableViewCellGroupedModel.h"

// Model
#import "HQLTableViewCellStyleDefaultModel.h"


@implementation HQLTableViewCellGroupedModel

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"headerTitle" : @"headerTitle",
        @"cells"       : @"cells"
    };
}

+ (NSValueTransformer *)cellsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:HQLTableViewCellGroupedModel.class];
}

@end
