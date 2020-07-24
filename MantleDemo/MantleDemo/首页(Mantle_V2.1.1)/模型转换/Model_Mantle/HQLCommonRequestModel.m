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
 
 ???: 即使属性名称与 JSON 字典中 key 的名称相同，你还是需要作映射
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"userId"     : @"userId",
        @"cityCode"   : @"cityCode",
        @"categoryId" : @"categoryId",
        @"marketId"   : @"marketId",
        @"floorId"    : @"floorId",
        @"storeId"    : @"storeId",
        @"storeName"  : @"storeName",
        @"brandId"    : @"brandId",
        @"goodsId"    : @"goodsId",
        @"page"       : @"page",
        @"limit"      : @"limit"
    };
}

@end
