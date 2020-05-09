//
//  HQLMainPageNavBtnModel.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 首页 5 个导航按钮模型
 
 - 找商场
 - 找品牌
 - 奢品专柜
 - 去领券
 - 嗨会员
 */
@interface HQLMainPageNavBtnModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *title; // 按钮标题
@property (nonatomic, readonly, copy) NSString *image; // 按钮图片
@property (nonatomic, readonly, copy) NSNumber *tag;   // 按钮 Tag 值

@end

NS_ASSUME_NONNULL_END
