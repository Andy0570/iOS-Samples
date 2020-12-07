//
//  YYCommonRequestModel.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/7/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYCommonRequestModel : NSObject

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
