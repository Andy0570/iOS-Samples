//
//  DismissingAnimationController.m
//  POPDemo
//
//  Created by Qilin Hu on 2020/5/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "DismissingAnimationController.h"

@implementation DismissingAnimationController


#pragma mark - UIViewControllerAnimatedTransitioning

// 定义了转场时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}
 
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    // 1.通过 viewControllerForKey: 方法获取 toView
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toView.userInteractionEnabled = YES;
    
    // 2.通过 viewControllerForKey: 方法获取 fromView
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    
    // 添加关闭动画和缩小动画。通过这两个动画的结合实现 modal view 的消失和移出屏幕.
    // 3.添加关闭动画
    POPBasicAnimation *closeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    closeAnimation.toValue = @(-fromView.layer.position.y);
    [closeAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    // 4.添加缩小动画
    POPSpringAnimation *scaleDownAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleDownAnimation.springBounciness = 20;
    scaleDownAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    [fromView.layer pop_addAnimation:closeAnimation forKey:@"closeAnimation"];
    [fromView.layer pop_addAnimation:scaleDownAnimation forKey:@"scaleDown"];
    
}

@end
