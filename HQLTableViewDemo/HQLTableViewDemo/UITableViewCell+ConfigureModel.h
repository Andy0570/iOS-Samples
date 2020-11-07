//
//  UITableViewCell+ConfigureModel.h
//  iOS Project
//
//  Created by Qilin Hu on 2020/11/07.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQLTableViewCellConfigureDelegate <NSObject>
@optional
- (NSString *)imageName;
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
- (void)hql_configureForKeyValueModel:(id<HQLTableViewCellConfigureDelegate>)model;

@end
