//
//  HQLVerticalPresentationController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLVerticalPresentationController.h"

//! 包含 presented view controller 的视图的圆角半径
static const CGFloat KCornerRadius = 16.0f;

@interface HQLVerticalPresentationController () <UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *presentationRoundedCornerWrappingView;
@end

@implementation HQLVerticalPresentationController

#pragma mark - Initialize

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        /**
         当使用 UIPresentationController 子类来自定义呈现控制器时，presented view controller 的 modalPresentationStyle 属性必须设置为 UIModalPresentationCustom
         */
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIView *)presentedView {
    // 返回在 -presentationTransitionWillBegin 方法中创建的外包装视图
    return self.presentationRoundedCornerWrappingView;
}

#pragma mark - Override

//  这是 presentation controller 在呈现视图之初时首先被调用的方法之一。
//  当这个方法被调用时，containerView 已经在视图层次结构中被创建。但是，presentedView 还没有被检索到。
- (void)presentationTransitionWillBegin
{
    // presentedView 属性的 Getter 方法默认返回 self.presentedViewController.view
    UIView *presentedViewControllerView = [super presentedView];
        
    // 将 presented view controller 的视图包裹在一个中间视图层次结构中。
    // 该中间层视图在左上角和右上角应用了阴影和圆角效果。
    // 最终的效果是使用两个中间视图构建的。
    //
    // presentationWrapperView =
    //   |- presentationRoundedCornerView   <- 添加 rounded corners (masksToBounds) 圆角
    //        |- presentedViewControllerWrapperView
    //             |- presentedViewControllerView (presentedViewController.view)
    //
    {
        /**
         presentationRoundedCornerView 的高度比 presented view controller 的视图高 KCornerRadius 的值。
         这是因为 cornerRadius 默认被应用于视图的所有角。
         由于该效果只要求对顶部两个角进行圆角处理，我们将视图底部的 KCornerRadius 点调整为位于
         屏幕的底部边缘以下位置。
         */
        UIView *presentationRoundedCornerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.frameOfPresentedViewInContainerView, UIEdgeInsetsMake(0, 0, -KCornerRadius, 0))];
        presentationRoundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        presentationRoundedCornerView.layer.cornerRadius = KCornerRadius;
        presentationRoundedCornerView.layer.masksToBounds = YES;
        self.presentationRoundedCornerWrappingView = presentationRoundedCornerView;
        
        /**
         为了撤销加在 presentationRoundedCornerView 上的额外高度，
         presentationViewControllerWrapperView 被 KCornerRadius 点插入.
         这也使 presentationViewControllerWrapperView 的边界大小与 frameOfPresentedViewInContainerView 的大小相匹配。
         */
        UIView *presentedViewControllerWrapperView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, KCornerRadius, 0))];
        presentedViewControllerWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 将 presentedViewControllerView 添加到 presentedViewControllerWrapperView.
        presentedViewControllerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds;
        [presentedViewControllerWrapperView addSubview:presentedViewControllerView];
        
        // 将 presentedViewControllerWrapperView 添加到 presentationRoundedCornerWrappingView.
        [presentationRoundedCornerView addSubview:presentedViewControllerWrapperView];
    }
    
    /**
     在 presentationWrapperView 后面添加一个黑色半透明背景视图，
     self.presentationView 是稍后添加的（由动画添加），所以这里添加的任何视图都会出现在 presentedView 后面。
     */
    {
        UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        dimmingView.backgroundColor = [UIColor blackColor];
        dimmingView.opaque = NO;
        dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
        self.dimmingView = dimmingView;
        [self.containerView addSubview:dimmingView];
        
        // 获取过渡期协调器以实现呈现，这样我们就可以在呈现动画的同时，淡化 dimmingView。
        id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
        
        self.dimmingView.alpha = 0.f;
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            self.dimmingView.alpha = 0.5f;
        } completion:NULL];
    }
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    /**
     Completed 参数的值与动画传递给 -completeTransition: 方法的值相同。
     在取消交互转换的情况下，它可能是 NO。
     
     就是说，在呈现动画发生时，异常终止了动画，这时我们需要手动释放未正常添加的视图
     */
    if (completed == NO)
    {
        /**
         系统会将 presented view controller 的视图从它的 superview 中移除，并同时处理 containerView。
         这隐含了从视图层次结构中删除在 -presentationTransitionWillBegin: 中创建的视图。 然而，我们仍然需要放弃对这些视图的强引用。
         */
        self.presentationRoundedCornerWrappingView = nil;
        self.dimmingView = nil;
    }
}

- (void)dismissalTransitionWillBegin
{
    // 获取过渡期协调器以实现退出，这样我们就可以在退出动画的同时，淡化 dimmingView。
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    // The value of the 'completed' argument is the same value passed to the
    // -completeTransition: method by the animator.  It may
    // be NO in the case of a cancelled interactive transition.
    if (completed == YES)
    {
        // The system removes the presented view controller's view from its
        // superview and disposes of the containerView.  This implicitly
        // removes the views created in -presentationTransitionWillBegin: from
        // the view hierarchy.  However, we still need to relinquish our strong
        // references to those view.
        self.presentationRoundedCornerWrappingView = nil;
        self.dimmingView = nil;
    }
}

#pragma mark -
#pragma mark Layout

//  This method is invoked whenever the presentedViewController's
//  preferredContentSize property changes.  It is also invoked just before the
//  presentation transition begins (prior to -presentationTransitionWillBegin).
//
//  当 presentedViewController 控制器内容大小变化时，就会调用这个方法， 比如适配横竖屏幕时，翻转屏幕时
//  可以使用 UIContentContainer 的方法来调整任何子视图控制器的大小或位置。
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}

//  When the presentation controller receives a
//  -viewWillTransitionToSize:withTransitionCoordinator: message it calls this
//  method to retrieve the new size for the presentedViewController's view.
//  The presentation controller then sends a
//  -viewWillTransitionToSize:withTransitionCoordinator: message to the
//  presentedViewController with this size as the first argument.
//
//  Note that it is up to the presentation controller to adjust the frame
//  of the presented view controller's view to match this promised size.
//  We do this in -containerViewWillLayoutSubviews.
//
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    // The presented view extends presentedViewContentSize.height points from
    // the bottom edge of the screen.
    CGRect presentedViewControllerFrame = containerViewBounds;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
    return presentedViewControllerFrame;
}

//  This method is similar to the -viewWillLayoutSubviews method in
//  UIViewController.  It allows the presentation controller to alter the
//  layout of any custom views it manages.
//
- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    
    self.dimmingView.frame = self.containerView.bounds;
    self.presentationRoundedCornerWrappingView.frame = UIEdgeInsetsInsetRect(self.frameOfPresentedViewInContainerView, UIEdgeInsetsMake(0, 0, -KCornerRadius, 0));
}

#pragma mark -
#pragma mark Tap Gesture Recognizer

//  IBAction for the tap gesture recognizer added to the dimmingView.
//  Dismisses the presented view controller.
//
- (IBAction)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark UIViewControllerTransitioningDelegate

//  If the modalPresentationStyle of the presented view controller is
//  UIModalPresentationCustom, the system calls this method on the presented
//  view controller's transitioningDelegate to retrieve the presentation
//  controller that will manage the presentation.  If your implementation
//  returns nil, an instance of UIPresentationController is used.
//
- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    NSAssert(self.presentedViewController == presented, @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController);
    
    return self;
}

//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the presentation of the incoming view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  presentation animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the dismissal of the presented view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  dismissal animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark -
#pragma mark UIViewControllerAnimatedTransitioning

// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
// 设置交互动画的百分比时间，容器控制器的动画需要与主动画保持同步
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.35 : 0;
}

//  The presentation animation is tightly integrated with the overall
//  presentation so it makes the most sense to implement
//  <UIViewControllerAnimatedTransitioning> in the presentation controller
//  rather than in a separate object.
//  核心，动画效果的实现
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
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
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // If NO is returned from -shouldRemovePresentersView, the view associated
    // with UITransitionContextFromViewKey is nil during presentation.  This
    // intended to be a hint that your animator should NOT be manipulating the
    // presenting view controller's view.  For a dismissal, the -presentedView
    // is returned.
    //
    // Why not allow the animator manipulate the presenting view controller's
    // view at all times?  First of all, if the presenting view controller's
    // view is going to stay visible after the animation finishes during the
    // whole presentation life cycle there is no need to animate it at all — it
    // just stays where it is.  Second, if the ownership for that view
    // controller is transferred to the presentation controller, the
    // presentation controller will most likely not know how to layout that
    // view controller's view when needed, for example when the orientation
    // changes, but the original owner of the presenting view controller does.
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    // This will be the current frame of fromViewController.view.
    CGRect __unused fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
    // For a presentation which removes the presenter's view, this will be
    // CGRectZero.  Otherwise, the current frame of fromViewController.view.
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    // This will be CGRectZero.
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    // For a presentation, this will be the value returned from the
    // presentation controller's -frameOfPresentedViewInContainerView method.
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    // We are responsible for adding the incoming view to the containerView
    // for the presentation (will have no effect on dismissal because the
    // presenting view controller's view was not removed).
    // 我们需要负责将传入的视图添加到容器视图中进行 presentation/dismissal
    [containerView addSubview:toView];
    
    if (isPresenting) {
        toViewInitialFrame.origin = CGPointMake(CGRectGetMinX(containerView.bounds), CGRectGetMaxY(containerView.bounds));
        toViewInitialFrame.size = toViewFinalFrame.size;
        toView.frame = toViewInitialFrame;
    } else {
        // Because our presentation wraps the presented view controller's view
        // in an intermediate view hierarchy, it is more accurate to rely
        // on the current frame of fromView than fromViewInitialFrame as the
        // initial frame (though in this example they will be the same).
        fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting)
            toView.frame = toViewFinalFrame;
        else
            fromView.frame = fromViewFinalFrame;
        
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
