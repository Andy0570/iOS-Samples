//
//  UITableViewCell+ConfigureModel.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright (c) 2020 独木舟的木 All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQLTableViewCellConfigureDelegate <NSObject>
@required
- (NSString *)imageName;
- (NSString *)titleLabelText;
@end

@protocol HQLTableViewCellKeyValueConfigureDelegate <NSObject>
@required
- (NSString *)titleLabelText;
- (NSString *)detailLabelText;
@end

@interface UITableViewCell (ConfigureModel)

/**
 配置查询 Cell

 @param model 按钮模型：图片 + 标题 + 指示箭头>
 */
- (void)hql_configureForModel:(id<HQLTableViewCellConfigureDelegate>)model;


/**
 配置数据显示 Cell

 @param model 模型：titleLabel + detailLabel
 */
- (void)hql_configureForKeyValueModel:(id<HQLTableViewCellKeyValueConfigureDelegate>)model;

@end
