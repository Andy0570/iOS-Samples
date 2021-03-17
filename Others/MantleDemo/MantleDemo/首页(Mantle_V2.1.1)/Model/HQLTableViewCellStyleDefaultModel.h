//
//  HQLTableViewCellStyleDefaultModel.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright (c) 2020 独木舟的木 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewCell+ConfigureModel.h"
#import <Mantle.h>

/**
  UITableViewCell 数据源模型：
 
  默认样式 UITableViewCellStyleDefault
 */
@interface HQLTableViewCellStyleDefaultModel : MTLModel <MTLJSONSerializing, HQLTableViewCellConfigureDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;

@end
