//
//  AAPLSwipeTransitionAnimator.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLSwipeTransitionAnimator.h"

@implementation AAPLSwipeTransitionAnimator

- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge {
    self = [self init];
    if (self) {
        _targetEdge = targetEdge;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35;
}

//| ----------------------------------------------------------------------------
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *fromView;
    UIView *toView;
    
    // In iOS 8, the viewForKey: method was introduced to get views that the
    // animator manipulates.  This method should be preferred over accessing
    // the view of the fromViewController/toViewController directly.
    // It may return nil whenever the animator should not touch the view
    // (based on the presentation style of the incoming view controller).
    // It may also return a different view for the animator to animate.
    //
    // Imagine that you are implementing a presentation similar to form sheet.
    // In this case you would want to add some shadow or decoration around the
    // presented view controller's view. The animator will animate that
    // decoration instead and the presented view controller's view will be a
    // child of the decoration.
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    /**
     如果是 presentation：
     toViewController 对应 presented view controller
     fromViewController 对应 presentingViewController
     
     否则，就相反
     */
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    /**
     根据我们配置的 targetEdge，推导出一个归一化的向量，用来偏移呈现视图控制器的 frame。
     */
    __block CGVector offset;
    if (self.targetEdge == UIRectEdgeTop)
        offset = CGVectorMake(0.f, 1.f);
    else if (self.targetEdge == UIRectEdgeBottom)
        offset = CGVectorMake(0.f, -1.f);
    else if (self.targetEdge == UIRectEdgeLeft)
        offset = CGVectorMake(1.f, 0.f);
    else if (self.targetEdge == UIRectEdgeRight)
        offset = CGVectorMake(-1.f, 0.f);
    else
        NSAssert(NO, @"targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.");
    
    if (isPresenting) {
        // For a presentation, the toView starts off-screen and slides in.
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toFrame.size.width * offset.dx * -1,
                                             toFrame.size.height * offset.dy * -1);
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
    }
    
    // We are responsible for adding the incoming view to the containerView
    // for the presentation.
    if (isPresenting)
        [containerView addSubview:toView];
    else
        // -addSubview places its argument at the front of the subview stack.
        // For a dismissal animation we want the fromView to slide away,
        // revealing the toView.  Thus we must place toView under the fromView.
        // 对于 dismissal 动画来说，fromView 和 toView 颠倒了，而且 fromView 需要滑出屏幕
        [containerView insertSubview:toView belowSubview:fromView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.frame = toFrame;
        } else {
            // 对于 dismissal 动画来说，fromView 被滑出屏幕
            fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width * offset.dx,
                                                     fromFrame.size.height * offset.dy);
        }
        
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        
        // Due to a bug with unwind segues targeting a view controller inside
        // of a navigation controller, we must remove the toView in cases where
        // an interactive dismissal was cancelled.  This bug manifests as a
        // soft UI lockup after canceling the first interactive modal
        // dismissal; further invocations of the unwind segue have no effect.
        //
        // The navigation controller's implementation of
        // -segueForUnwindingToViewController:fromViewController:identifier:
        // returns a segue which only dismisses the currently presented
        // view controller if it determines that the navigation controller's
        // view is not in the view hierarchy at the time the segue is invoked.
        // The system does not remove toView when we invoke -completeTransition:
        // with a value of NO if this is a dismissal transition.
        //
        // Note that it is not necessary to check for further conditions
        // specific to this bug (e.g. isPresenting==NO &&
        // [toViewController isKindOfClass:UINavigationController.class])
        // because removing toView is a harmless operation in all scenarios
        // except for a successfully completed presentation transition, where
        // it would result in a blank screen.
        if (wasCancelled)
            [toView removeFromSuperview];
        
        // When we complete, tell the transition context
        // passing along the BOOL that indicates whether the transition
        // finished or not.
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
