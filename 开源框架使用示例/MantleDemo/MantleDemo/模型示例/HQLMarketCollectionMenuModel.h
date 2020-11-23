//
//  HQLMarketCollectionMenuModel.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/// 通用导航按钮数据模型，图片+标题
@interface HQLMarketCollectionMenuModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *image;

@end

NS_ASSUME_NONNULL_END
