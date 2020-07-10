//
//  HQLDatePickerPresentationController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLDatePickerPresentationController.h"

@interface HQLDatePickerPresentationController ()
/** 黑色半透明背景 */
@property (nonatomic, strong) UIView *dimmingView;
@end

@implementation HQLDatePickerPresentationController

#pragma mark - <UIViewControllerTransitioningDelegate>

/**
 告诉控制器，谁是动画主管(UIPresentationController)，因为此类继承了 UIPresentationController，就返回了 self
 */
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source API_AVAILABLE(ios(8.0)) {
    return self;
}

// 以下两个方法，该示例中不去实现，即：使用系统默认的 Presented 动画效果，就是从下而上的效果。
// 由于我们没有指定具体动画的效果类，所以第三步也就不用去实现。
/*
// 返回的对象控制 Presented 时的动画 (该类负责开始动画的具体细节)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return nil;
}

// 由返回的控制器控制 dismissed 时的动画 (该类负责结束动画的具体细节)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
}
*/

/*
// 以下两个方法是可交互转换，具体示例可参考 Swipe 
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    
}
*/

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

// 呈现过渡动画结束时，被呈现的视图在容器视图中的位置
- (CGRect)frameOfPresentedViewInContainerView {
    // 这里直接按照想要的大小写死，其实这样写不好，在其他 Demo 里，我们将按照苹果官方Demo，写灵活的获取方式。
    CGFloat height = 300.f;
    
    CGRect containerViewBounds = self.containerView.bounds;
    containerViewBounds.origin.y = containerViewBounds.size.height - height;
    containerViewBounds.size.height = height;
    return containerViewBounds;
}

//  This method is invoked whenever the presentedViewController's
//  preferredContentSize property changes.  It is also invoked just before the
//  presentation transition begins (prior to -presentationTransitionWillBegin).
//  建议就这样重写就行，这个应该是控制器内容大小变化时，就会调用这个方法， 比如适配横竖屏幕时，翻转屏幕时
//  可以使用 UIContentContainer 的方法来调整任何子视图控制器的大小或位置。
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
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


@end
