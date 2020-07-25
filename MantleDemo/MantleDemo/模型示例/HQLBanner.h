//
//  HQLBanner.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Banner 模型
 
 首页 Banner 模型（1.3.1）
 商品品牌右侧集合视图 Banner 模型（1.5.2.2）
 女装 Banner 模型（1.10.2.1）
 商圈主页 Banner 模型（2.2）
 */
@interface HQLBanner : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy)   NSString *name;  // 广告语
@property (nonatomic, readonly, strong) NSURL *imageURL; // 展示图片 URL
@property (nonatomic, readonly, strong) NSURL *linkURL;  // 跳转 URL
@property (nonatomic, readonly, copy)   NSString *note;  // 描述信息

@end

NS_ASSUME_NONNULL_END

/**
 请求端口
 GET /api-marking/sms/advertise/category/banner
 
 
 示例模型
 {
     "name": "汽车推荐广告16",
     "pic": "http://47.102.118.65/RjSZFvSuwB7VXa1.jpg",
     "url": "xxx",
     "note": null
 }
 */
