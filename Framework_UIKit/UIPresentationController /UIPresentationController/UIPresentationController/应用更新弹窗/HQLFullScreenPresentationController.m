//
//  HQLFullScreenPresentationController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLFullScreenPresentationController.h"

@interface HQLFullScreenPresentationController () <UIViewControllerAnimatedTransitioning>
/** 黑色半透明背景 */
@property (nonatomic, strong) UIView *dimmingView;
@end

@implementation HQLFullScreenPresentationController

#pragma mark - <UIViewControllerTransitioningDelegate>

/**
 告诉控制器，谁是动画主管(UIPresentationController)，因为此类继承了 UIPresentationController，就返回了self
 */
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source API_AVAILABLE(ios(8.0)) {
    return self;
}

// 返回的对象控制 Presented 时的动画 (该类负责开始动画的具体细节)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

// 由返回的控制器控制 dismissed 时的动画 (该类负责结束动画的具体细节)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

#pragma mark - Initialize

// 覆写父类的指定初始化方法
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        // 设置模态样式
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

#pragma mark - Custom Accessors

// 背景遮罩视图
- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] init];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.opaque = NO; // 是否不透明，默认值 YES 表示不透明，NO 表示透明
        _dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 添加点击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)];
        [_dimmingView addGestureRecognizer:tapGestureRecognizer];
    }
    return _dimmingView;
}

#pragma mark - Actions

// 点击背景遮罩视图，退出当前视图
- (void)dimmingViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Override

/**
 呈现过渡即将开始时被调用，可以在此方法中创建和设置自定义动画所需的 view
 */
- (void)presentationTransitionWillBegin {
    // 将「背景遮罩视图」添加到动画容器视图中
    [self.containerView addSubview:self.dimmingView];
    
    // 获取 presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    // 动画期间，背景视图的动画方式
    self.dimmingView.alpha = 0.f;
    __weak __typeof(self)weakSelf = self;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        weakSelf.dimmingView.alpha = 0.5f;
    } completion:nil];
}

// 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
- (void)presentationTransitionDidEnd:(BOOL)completed {
    // 在取消动画的情况下，可能为 NO，这种情况下，应该取消视图的引用，防止视图没有释放
    if (!completed) {
        [self.dimmingView removeFromSuperview];
    }
}

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin {
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    __weak __typeof(self)weakSelf = self;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        weakSelf.dimmingView.alpha = 0.f;
    } completion:nil];
}

// 消失过渡完成之后调用，此时应该将视图移除，防止强引用
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.dimmingView removeFromSuperview];
    }
}

//| --------以下四个方法，是按照苹果官方Demo里的，都是为了计算目标控制器View的frame的----------------
//  当 presentation controller 接收到 -viewWillTransitionToSize:withTransitionCoordinator:
//  消息时，它会调用该方法来获取并返回 presentedViewController 的视图的新的尺寸。
//
//  presentation controller 随后就会以该方法中返回的第一个参数，发送
//  -viewWillTransitionToSize:withTransitionCoordinator:  消息给 presentedViewController
//
//  Note that it is up to the presentation controller to adjust the frame
//  of the presented view controller's view to match this promised size.
//  We do this in -containerViewWillLayoutSubviews.
//
//  需要注意的是，调整 presented view controller 的视图的大小是由 presentation controller 决定的。
//  我们只不过会在 -containerViewWillLayoutSubviews 方法中干这件事情
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

// 呈现过渡动画结束时，被呈现的视图在容器视图中的位置
// 在我们的自定义呈现中，被呈现的 view 并没有完全完全填充整个屏幕，
// 被呈现的 view 的过渡动画之后的最终位置，是由 UIPresentationViewController 来负责定义的。
// 我们重载 frameOfPresentedViewInContainerView 方法来定义这个最终位置
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
//  自定义子视图布局
- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    
    self.dimmingView.frame = self.containerView.bounds;
}


//  This method is invoked whenever the presentedViewController's
//  preferredContentSize property changes.  It is also invoked just before the
//  presentation transition begins (prior to -presentationTransitionWillBegin).
//  建议就这样重写就行，这个应该是控制器内容大小变化时，就会调用这个方法， 比如适配横竖屏幕时，翻转屏幕时
//  可以使用UIContentContainer的方法来调整任何子视图控制器的大小或位置。
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}

#pragma mark - <UIViewControllerAnimatedTransitioning>

// This is used for percent driven interactive transitions, as well as for
// container controllers that have companion animations that might need to
// synchronize with the main animation.
// 动画时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? 0.55 : 0;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
// 核心，动画效果的实现
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // 1.获取源控制器、目标控制器、动画容器 view
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // 2.获取源控制器、目标控制器的 View，但是注意二者在开始动画，消失动画，身份是不一样的：
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [containerView addSubview:toView]; //必须添加到动画容器View上。
    
    // 判断是 present 还是 dismiss
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    CGFloat screenWidth = CGRectGetWidth(containerView.bounds);
    CGFloat screenHeight = CGRectGetHeight(containerView.bounds);
    
    // 左右留 35，上下留 80
    
    // 屏幕顶部
    CGFloat x = 35.f;
    CGFloat y = - screenHeight;
    CGFloat width = screenWidth - x * 2;
    CGFloat height = screenHeight - 80.f * 2;
    CGRect topFrame = CGRectMake(x, y, width, height);
    
    // 屏幕中间
    CGRect centerFrame = CGRectMake(x, 80.0f, width, height);
    
    // 屏幕底部
    //加10是因为动画果冻效果，会露出屏幕一点
    CGRect bottomFrame = CGRectMake(x, screenHeight + 10, width, height);
    
    if (isPresenting) {
        toView.frame = topFrame;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    // duration： 动画时长
    // delay： 决定了动画在延迟多久之后执行
    // damping：速度衰减比例。取值范围0 ~ 1，值越低震动越强
    // velocity：初始化速度，值越高则物品的速度越快
    // UIViewAnimationOptionCurveEaseInOut 加速，后减速
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (isPresenting)
            toView.frame = centerFrame;
        else
            fromView.frame = bottomFrame;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

// This is a convenience and if implemented will be invoked by the system when the transition context's completeTransition: method is invoked.
// 动画结束
- (void)animationEnded:(BOOL) transitionCompleted {
    
}

@end
