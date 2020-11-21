//
//  UITableViewCell+ConfigureModel.h
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQLTableViewCellConfigureDelegate <NSObject>
@required
- (NSString *)imageName;      // cell 图片名称
- (NSString *)titleLabelText; // cell 标题
@end

@protocol HQLTableViewCellKeyValueConfigureDelegate <NSObject>
@required
- (NSString *)titleLabelText;  // cell 标题
- (NSString *)detailLabelText; // cell 子标题
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
