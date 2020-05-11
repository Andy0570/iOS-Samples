//
//  CollectionViewCell.h
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义 UICollectionViewCell 子类
@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

@end

NS_ASSUME_NONNULL_END
