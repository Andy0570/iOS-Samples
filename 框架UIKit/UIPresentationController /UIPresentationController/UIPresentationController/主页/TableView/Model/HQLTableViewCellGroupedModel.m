//
//  HQLTableViewCellGroupedModel.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

@implementation HQLTableViewCellGroupedModel

#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"headerTitle" : @"headerTitle",
        @"cells"       : @"cells"
    };
}

// MARK: JSON Array <——> NSArray<Model>
+ (NSValueTransformer *)cellsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:HQLTableViewCellStyleDefaultModel.class];
}

@end
