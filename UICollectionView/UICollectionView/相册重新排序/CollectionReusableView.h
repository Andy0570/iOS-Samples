//
//  CollectionReusableView.h
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义 UICollectionReusableView 子类，用于设置 header 和 footer
@interface CollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *label;

@end

NS_ASSUME_NONNULL_END
