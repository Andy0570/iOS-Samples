//
//  HQLCollectionCycleScrollView.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/12.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLCollectionCycleScrollViewHeight;

@protocol HQLCollectionCycleScrollViewDelegate <NSObject>
@required
// 选中了某一个 Banner 图片后调用
- (void)selectedScrollViewItemAtIndex:(NSInteger)index;
@end

/**
  🥰 可复用模块，集合视图 header/footer view 轮播器
 
 子品类 Banner 轮播器，集合视图 footer view
 找品牌 - 商品品牌 顶部 Banner 轮播器
 商圈首页 - 顶部 Banner 轮播器
 */
@interface HQLCollectionCycleScrollView : UICollectionReusableView

// 轮播图数组
@property (nonatomic, copy) NSArray<NSURL *> *imageGroupArray;
@property (nonatomic, weak) id<HQLCollectionCycleScrollViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
