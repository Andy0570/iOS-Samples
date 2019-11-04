//
//  UIButton+AdjustImageAndTitle.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/7/11.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AdjustImageAndTitle)

// 上下居中，图片在上，文字在下
- (void)hql_verticalCenterImageAndTitle:(CGFloat)spacing;
- (void)hql_verticalCenterImageAndTitle; //默认6.0

// 左右居中，文字在左，图片在右
- (void)hql_horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)hql_horizontalCenterTitleAndImage; //默认6.0

// 左右居中，图片在左，文字在右
- (void)hql_horizontalCenterImageAndTitle:(CGFloat)spacing;
- (void)hql_horizontalCenterImageAndTitle; //默认6.0

// 文字居中，图片在左边
- (void)hql_horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
- (void)hql_horizontalCenterTitleAndImageLeft; //默认6.0

// 文字居中，图片在右边
- (void)hql_horizontalCenterTitleAndImageRight:(CGFloat)spacing;
- (void)hql_horizontalCenterTitleAndImageRight; //默认6.0

@end
