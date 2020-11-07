//
//  HQLArrayDataSource.h
//  PhotoData
//
//  Created by HuQilin on 2017/6/11.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 配置 cell 的 Block 对象

 @param cell cell对象
 @param item 模型对象
 */
typedef void(^HQLTableViewCellConfigureBlock)(id cell,id item);


/**
 配置 tableView 列表的数据源类
 
 !!!: 适用于 UITableViewStylePlain 样式
 
 复用 UITableViewDataSource 协议方法：
 - tableView: numberOfRowsInSection:
 - tableView: cellForRowAtIndexPath:
 */
@interface HQLArrayDataSource : NSObject <UITableViewDataSource>

/**
 HQLArrayDataSource 的指定初始化方法

 @param items 数组模型
 @param reuseIdentifier cell 复用标识符
 @param configureBlock 配置 cell 的 Block 对象
 @return HQLArrayDataSource 实例对象
 */
- (instancetype)initWithItems:(NSArray *)items cellReuseIdentifier:(NSString *)reuseIdentifier configureCellBlock:(HQLTableViewCellConfigureBlock)configureBlock;
- (instancetype)init NS_UNAVAILABLE;

/**
 根据 index 找到 item 模型

 @param indexPath index 索引
 @return item 模型
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
