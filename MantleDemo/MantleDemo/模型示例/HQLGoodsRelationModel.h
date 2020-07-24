//
//  HQLGoodsRelationModel.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 优惠券关联的「商品」
 */
@interface HQLGoodsRelationModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSNumber *ID;       // 优惠券 ID
@property (nonatomic, readonly, strong) NSNumber *couponId; // 优惠券 ID
@property (nonatomic, readonly, strong) NSNumber *productId; // 商品 ID
@property (nonatomic, readonly, copy) NSString *productName; // 商品名称
@property (nonatomic, readonly, copy) NSString *productSn;   // 商品Sn编号
@property (nonatomic, readonly, strong) NSNumber *producPrice; // 商品价格


@end

NS_ASSUME_NONNULL_END

/**
 示例模型
 
 {
     "id": 10,
     "couponId": 24,
     "productId": 1,
     "productName": "小米 红米5A 全网通版 3GB+32GB 香槟金 移动联通电信4G手机 双卡双待",
     "productSn": "7437789",
     "productPrice": null
 }
 */
