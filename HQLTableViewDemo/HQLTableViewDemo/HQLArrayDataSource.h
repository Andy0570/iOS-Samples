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
 配置cell的Block对象

 @param cell cell对象
 @param item 模型对象
 */
typedef void(^HQLTableViewCellConfigureBlock)(id cell,id item);


/**
 配置 tableView 列表的数据源类
 
 MARK: 适用于 UITableViewStylePlain 样式
 
 复用 UITableViewDataSource 协议方法：
 - tableView: numberOfRowsInSection:
 - tableView: cellForRowAtIndexPath:
 */
@interface HQLArrayDataSource : NSObject <UITableViewDataSource>

/**
 HQLArrayDataSource 的指定初始化方法

 @param itemsArray 参数一：数组模型
 @param reuserIdentifier 参数二：cell复用标识符
 @param configureBlock 参数三：配置cell的Block对象
 @return 返回值：HQLArrayDataSource 实例对象
 */
- (id)initWithItemsArray:(NSArray *)itemsArray
    cellReuserIdentifier:(NSString *)reuserIdentifier
          configureBlock:(HQLTableViewCellConfigureBlock)configureBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/**
 根据 index 找到 item 模型

 @param indexPath index 索引
 @return item 模型
 */
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
