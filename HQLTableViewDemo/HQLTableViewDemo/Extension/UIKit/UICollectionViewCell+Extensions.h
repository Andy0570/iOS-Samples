//
//  UICollectionViewCell+Extensions.h
//  SeaTao
//
//  Created by Qilin Hu on 2021/1/21.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (Extensions)

/// 高亮色
/// self.selectedBackgroundView.backgroundColor 的简短语法
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@end

NS_ASSUME_NONNULL_END
