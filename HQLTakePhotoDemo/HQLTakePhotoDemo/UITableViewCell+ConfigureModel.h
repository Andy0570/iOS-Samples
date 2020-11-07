//
//  UITableViewCell+ConfigureModel.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/6/7.
//  Copyright © 2017年 ToninTech. All rights reserved.
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
