//
//  PresentingAnimationController.m
//  POPDemo
//
//  Created by Qilin Hu on 2020/5/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "PresentingAnimationController.h"

@implementation PresentingAnimationController


#pragma mark - UIViewControllerAnimatedTransitioning

// 定义了转场时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

// 定义转场动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // 1.通过 viewControllerForKey: 方法获取 fromView
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;
    
    // 2.通过 viewControllerForKey: 方法获取 toView
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.frame = CGRectMake(0,
                              0,
                              CGRectGetWidth(transitionContext.containerView.bounds) - 100.f,
                              CGRectGetHeight(transitionContext.containerView.bounds) - 280.f);
    CGPoint p = CGPointMake(transitionContext.containerView.center.x, -transitionContext.containerView.center.y);
    toView.center = p;
    [transitionContext.containerView addSubview:toView];
    
    // 3.添加 position 位置动画，将 view 从屏幕顶部下落到中央
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(transitionContext.containerView.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    // 4.添加 scale 缩放动画，将 view 先放大然后缩小到正常大小
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

@end
