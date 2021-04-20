//
//  HQLBaseCollectionViewCell.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/3/22.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQLTableViewModel;

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLBaseCollectionViewCellHeight;

/**
 集合视图通用基类，可以在子类中通过覆盖 layoutSubviews 方法重新布局

 视图元素：image View、title Label
 布局方式：上下布局
 布局尺寸：|-10-60-0-17-3-|
*/
@interface HQLBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly, strong) UIImageView *imageView;
@property (nonatomic, readonly, strong) UILabel *titleLabel; // 默认为 #12 字体

@property (nonatomic, strong) HQLTableViewModel *navigationItem;

@end

NS_ASSUME_NONNULL_END
