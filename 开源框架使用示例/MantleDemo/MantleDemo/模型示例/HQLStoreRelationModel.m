//
//  HQLStoreRelationModel.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLStoreRelationModel.h"

@implementation HQLStoreRelationModel

#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"ID"        : @"id",
        @"couponId"  : @"couponId",
        @"storeId"   : @"storeId",
        @"storeName" : @"storeName",
        @"cityCode"  : @"cityId"
    };
}

@end
