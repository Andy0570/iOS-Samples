//
//  AAPLSlideTransitionAnimator.h
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 实现左右滑动的手势动画
 */
@interface AAPLSlideTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

//! The value for this property determines which direction the view controllers
//! slide during the transition.  This must be one of UIRectEdgeLeft or
//! UIRectEdgeRight.
@property (nonatomic, readwrite) UIRectEdge targetEdge;

- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge;

@end

NS_ASSUME_NONNULL_END
