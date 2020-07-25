//
//  HQLCategory.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 品类模型
 
 商品品类模型（1.2.1）
 商品子品类模型（1.10.1.1）
 */
@interface HQLCategory : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, strong) NSNumber *ID;        // 品类 ID
@property (nonatomic, readonly, strong) NSNumber *parentId;  // 父品类 ID
@property (nonatomic, readonly, copy)   NSString *name;      // 品类名称
@property (nonatomic, readonly, strong) NSURL    *iconURL;   // 子品类图标 URL

@end

NS_ASSUME_NONNULL_END

/**
 请求接口
 GET /api-goods/pms/category/onelevel
 
 
 示例模型
 {
     "id": 0,
     "parentId": 0,
     "name": "首页",
     "icon": null
 }
 */
