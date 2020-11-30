//
//  UILabel+ChangeRightAndLeftAlignment.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ChangeRightAndLeftAlignment)

/**
 分散对齐标题文字，不带冒号:

 @param labelWidth 标签宽度
 */
- (void)hql_changeRightAndLeftAlignment:(CGFloat)labelWidth;


/**
  分散对齐标题文字,带冒号:

 @param labelWidth 标签宽度
 */
- (void)hql_changeRightAndLeftAlignmentWithDot:(CGFloat)labelWidth;

@end

NS_ASSUME_NONNULL_END
