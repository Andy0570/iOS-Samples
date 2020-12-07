//
//  AnimalsViewController.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/// 购物车商品模型
@interface HQLShoppingCartGoodsModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSNumber *memberId;     // 会员 ID
@property (nonatomic, readonly, copy) NSString *memberNickName; // 会员名
@property (nonatomic, readonly, strong) NSNumber *storeId;      // 店铺 ID
@property (nonatomic, readonly, copy) NSString *storeName;      // 店铺名称
@property (nonatomic, readonly, strong) NSNumber *productId;    // 商品 ID
@property (nonatomic, readonly, copy) NSString *productSkuCode; // 产品库存编号
@property (nonatomic, readonly, copy) NSString *productSn;      // 产品 Sn 编号
@property (nonatomic, readonly, copy) NSString *productName;    // 商品名称
@property (nonatomic, readonly, strong) NSURL  *imageURL;       // 商品图片 URL
@property (nonatomic, readonly, strong) NSNumber *quantity;     // 购买数量
@property (nonatomic, readonly, strong) NSNumber *price;        // 商品价格
@property (nonatomic, readonly, copy) NSString *specification1; // 规格 1
@property (nonatomic, readonly, copy) NSString *specification2; // 规格 2
@property (nonatomic, readonly, copy) NSString *specification3; // 规格 3
@property (nonatomic, getter =isChecked) BOOL checked;          // 商品是否已选中

@end

NS_ASSUME_NONNULL_END

/**
 模型示例
 
 {
     "memberId": 1,
     "memberNickname": "张三",
     "storeId": 1,
     "storeName": "店铺名称"，
     "productId": 123,
     "productSkuCode": "201808270028004",
     "productSn": "7437789",
     "productName": "小米 红米5A 全网通版 3GB+32GB 香槟金 移动联通电信4G手机 双卡双待",
     "productPic": "https://example.com/example.jpg",
     "quantity": 1,
     "price": 699.00,
     "sp1": "银色",
     "sp2": "32G",
     "sp3": null,
     "checked": 0
 }
 */
