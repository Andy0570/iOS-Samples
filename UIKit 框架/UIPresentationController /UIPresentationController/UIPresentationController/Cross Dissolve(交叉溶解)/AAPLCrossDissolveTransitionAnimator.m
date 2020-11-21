//
//  AAPLCrossDissolveTransitionAnimator.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLCrossDissolveTransitionAnimator.h"

@implementation AAPLCrossDissolveTransitionAnimator

#pragma mark - <UIViewControllerAnimatedTransitioning>

// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
// 设置交互动画的百分比时间，容器控制器的动画需要与主动画保持同步
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
// 如果过渡是交互式的，而不是百分比驱动的，这个方法只能为空。
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // 对于呈现动画来说
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // 对于返回动画来说
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *fromView;
    UIView *toView;
    
    /**
     在 iOS 8中，引入了 viewForKey: 方法，以获取动画执行器需要操作的视图。
     相对于直接访问 fromViewController/toViewController 的视图，该方法为首选方法。
     */
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    fromView.alpha = 1.0f;
    toView.alpha = 0.0f;
    
    // 我们需要负责将传入的视图添加到容器视图中进行 presentation/dismissal
    [containerView addSubview:toView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    // !!!: 动画执行的核心，alpha 0.0 -> 1.0
    [UIView animateWithDuration:transitionDuration animations:^{
        fromView.alpha = 0.0f;
        toView.alpha = 1.0;
    } completion:^(BOOL finished) {
        /**
         当我们的动画执行完成后，需要给 transition context 传递一个 BOOL 值
         以表示动画是否执行完成
         */
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
