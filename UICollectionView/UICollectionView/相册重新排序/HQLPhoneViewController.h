//
//  HQLPhoneViewController.h
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/10.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UICollectionView 及其新功能 drag and drop
 */
@interface HQLPhoneViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 参考：<https://github.com/pro648/tips/wiki/UICollectionView%E5%8F%8A%E5%85%B6%E6%96%B0%E5%8A%9F%E8%83%BDdrag-and-drop>
 
 如果觉得从数据源获取数据很耗时，可以使用 UICollectionViewDataSourcePrefetching 协议，
 该协议会协助你的数据源在还未调用 collectionView:cellForItemAtIndexPath: 方法时进行预加载。
 
 
 ## UICollectionViewDataSourcePrefetching 协议，【iOS 10 新增】
 参考：
 
 [掘金：iOS10 - PrefetchDataSource 详解](https://juejin.im/entry/580f21d9da2f60004f42a9f8)
 [简书：jiiOS 开发之 UICollectionViewDataSourcePrefetching](https://www.jianshu.com/p/a61565b01628)
 */
