//
//  HQLBrandListViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/5/27.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 左右联动的品牌列表页面
 
 该页面中：
 1. 左边是一个 UITableView 列表视图；
 2. 右边是一个 UICollectionView 集合视图；
 3. 集合视图中的 header view 轮播器通过 SDCycleScrollView 框架实现；
 */
@interface HQLBrandListViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
