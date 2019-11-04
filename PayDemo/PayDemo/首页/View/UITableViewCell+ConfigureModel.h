//
//  UITableViewCell+ConfigureModel.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/6/7.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

// 配置 Cell 样式：Image + Title + 指示箭头>
@protocol HQLTableViewCellConfigureDelegate <NSObject>
@required
- (NSString *)imageName;
- (NSString *)titleLabelText;
@end

// 配置 Cell 样式：Title + DetailTitle
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
