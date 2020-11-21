//
//  HQLGroupedArrayDataSource.h
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 配置cell的Block对象
 
 @param cell cell对象
 @param item 模型对象
 */
typedef void(^HQLTableViewCellConfigureBlock)(id cell,id item);

/**
 配置 tableView 列表的数据源类
 
 适用于 UITableViewStyleGrouped 样式
 
 复用 UITableViewDataSource 协议方法：
 - tableView: titleForHeaderInSection:
 - tableView: numberOfSectionsInTableView:
 - tableView: numberOfRowsInSection:
 - tableView: cellForRowAtIndexPath:
 */
@interface HQLGroupedArrayDataSource : NSObject <UITableViewDataSource>

/**
 HQLArrayDataSource 的指定初始化方法
 
 @param groupsArray 数组模型
 @param reuseIdentifier cell复用标识符
 @param configureBlock 配置cell的Block对象
 @return HQLArrayDataSource 实例对象
 */
- (id)initWithGroupsArray:(NSArray *)groupsArray
      cellReuseIdentifier:(NSString *)reuseIdentifier
           configureBlock:(HQLTableViewCellConfigureBlock)configureBlock;

/**
 根据 index 找到 item 模型
 
 @param indexPath index 索引
 @return item 数据模型
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
