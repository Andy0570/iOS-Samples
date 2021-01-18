//
//  HQLCommonRequestModel.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCommonRequestModel.h"

@implementation HQLCommonRequestModel

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _userId = @0;
    }
    return self;
}

#pragma mark - <MTLJSONSerializing>

/**
 模型和 JSON 字典之间的映射
 
 ???: 当属性名称与 JSON 字典中 key 的名称完全相同时，就没必要再写以下的样板代码了！
 */
//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    return @{
//        @"userId"     : @"userId",
//        @"cityCode"   : @"cityCode",
//        @"categoryId" : @"categoryId",
//        @"marketId"   : @"marketId",
//        @"floorId"    : @"floorId",
//        @"storeId"    : @"storeId",
//        @"storeName"  : @"storeName",
//        @"brandId"    : @"brandId",
//        @"goodsId"    : @"goodsId",
//        @"page"       : @"page",
//        @"limit"      : @"limit"
//    };
//}

// 当 Model 属性名称与 JSON 字典中的 key 完全相同时，使用以下便捷方法
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:HQLCommonRequestModel.class];
}

@end
