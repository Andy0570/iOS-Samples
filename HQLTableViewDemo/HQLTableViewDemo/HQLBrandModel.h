//
//  HQLBrandModel.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/5/27.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/// 品牌模型
@interface HQLBrandModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy)   NSString *name; // 品牌名称
@property (nonatomic, readonly, strong) NSURL *logoUrl; // 品牌 Logo URL

@end

NS_ASSUME_NONNULL_END
