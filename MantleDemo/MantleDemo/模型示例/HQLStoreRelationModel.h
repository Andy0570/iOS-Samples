//
//  HQLStoreRelationModel.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 优惠券关联的「店铺」
 */
@interface HQLStoreRelationModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSNumber *ID;   // 优惠券 ID
@property (nonatomic, readonly, strong) NSNumber *couponId; // 优惠券 ID
@property (nonatomic, readonly, strong) NSNumber *storeId;  // 店铺 ID
@property (nonatomic, readonly, copy)   NSString *storeName; // 店铺名称
@property (nonatomic, readonly, strong) NSNumber *cityCode; // 城市代码

@end

NS_ASSUME_NONNULL_END

/**
 模型示例：
 {
    "id": 1,
    "couponId": 22,
    "storeId": 3,
    "storeName": "店铺名称22",
    "cityId": 320200
 },
 
 */
