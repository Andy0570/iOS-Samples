//
//  HQLArrayDataSource.h
//  Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
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
 
 ⚠️ 适用于 UITableViewStylePlain 样式
 
 复用 UITableViewDataSource 协议方法：
 - tableView: numberOfRowsInSection:
 - tableView: cellForRowAtIndexPath:
 */
@interface HQLArrayDataSource : NSObject <UITableViewDataSource>

/**
 HQLArrayDataSource 的指定初始化方法

 @param itemsArray 参数一：数组模型
 @param reuserIdentifier 参数二：cell 复用标识符
 @param configureBlock 参数三：配置 cell 的 Block 对象
 @return 返回值：HQLArrayDataSource 实例对象
 */
- (id)initWithItemsArray:(NSArray *)itemsArray
    cellReuserIdentifier:(NSString *)reuserIdentifier
          configureBlock:(HQLTableViewCellConfigureBlock)configureBlock;

/**
 根据 index 找到 item 模型

 @param indexPath index 索引
 @return item 模型
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
