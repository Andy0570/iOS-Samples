//
//  HQLCommonRequestModel.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 通用请求数据模型
 
 该模型可适用于大多数分页数据请求
 */
@interface HQLCommonRequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readwrite, strong) NSNumber *userId;     // 用户 ID
@property (nonatomic, readwrite, strong) NSNumber *cityCode;   // 城市代码
@property (nonatomic, readwrite, strong) NSNumber *categoryId; // 集合 ID
@property (nonatomic, readwrite, strong) NSNumber *marketId;   // 商场 ID
@property (nonatomic, readwrite, strong) NSNumber *floorId;    // 楼层 ID
@property (nonatomic, readwrite, strong) NSNumber *storeId;    // 店铺 ID
@property (nonatomic, readwrite, strong) NSString *storeName;  // 店铺名称
@property (nonatomic, readwrite, strong) NSNumber *brandId;    // 品牌 ID
@property (nonatomic, readwrite, strong) NSNumber *goodsId;    // 商品 ID
@property (nonatomic, readwrite, strong) NSNumber *page;       // 分页开始位置
@property (nonatomic, readwrite, strong) NSNumber *limit;      // 分页大小

@end

NS_ASSUME_NONNULL_END

/**
 !!!: 使用此类作为请求数据模型，请在 YTKRequest 中自定义请求参数
 
 | 请求参数   | 描述         |
 | ---------- | ---------- |
 | userid     | 用户 ID  |
 | cityCode   | 城市代码     |
 | categoryId | 一级品类 ID  |
 | productid  | 产品 ID      |
 | page       | 分页开始位置  |
 | limit      | 分页大小     |
 
 - (id)requestArgument {
     return @{
         @"userId"     : _requestModel.userId,
         @"cityCode"   : _requestModel.cityCode,
         @"categoryId" : _requestModel.categoryId,
         @"marketId"   : _requestModel.marketId,
         @"floorId"    : _requestModel.floorId,
         @"storeId"    : _requestModel.storeId,
         @"brandId"    : _requestModel.brandId,
         @"goodsId"    : _requestModel.goodsId,
         @"page"       : _requestModel.page,
         @"limit"      : _requestModel.limit
     };
 }
 
 */
