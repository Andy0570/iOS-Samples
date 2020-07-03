//
//  AAPLSwipeTransitionAnimator.h
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 在当前视图控制器上滑动进入的视图控制器的过渡动画器。
 */
@interface AAPLSwipeTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite) UIRectEdge targetEdge;

- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge;

@end

NS_ASSUME_NONNULL_END
