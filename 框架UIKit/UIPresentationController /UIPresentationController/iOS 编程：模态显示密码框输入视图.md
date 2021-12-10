# iOS 编程：模态显示密码框输入视图

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/105702.jpg)



废话不多说，本教程将教你实现以上样式的密码框输入视图。要点如下：

* 该密码输入页面是以自定义模态视图的转场动画的方式实现的。通过本教程，你会对 `UIPresentationController`、`<UIViewControllerTransitioningDelegate>`、`<UIViewControllerAnimatedTransitioning>` 等几个类有所了解；
* 受益于站在巨人的肩膀上的优势，本教程中使用了 `Masonry` 框架实现相关视图元素的自动布局，还使用了 `YYKit` 框架中的部分工具类方法。



![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/131237.gif)

## 自定义 UIPresentationController 子类对象

首先，你需要自定义一个 `UIPresentationController` 子类对象。

```objective-c
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLVerticalPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@end

NS_ASSUME_NONNULL_END
```



等一下，`UIPresentationController` 是何许人也？

`UIPresentationController` 对象为所呈现的视图控制器提供高级视图转换管理功能，我们通过它实现视图控制器之间的转场动画。

通过模态方式呈现视图控制器的常用方法是：

```objective-c
UIViewController *viewControllerA = [[UIViewController alloc] init];
UIViewController *viewControllerB = [[UIViewController alloc] init];
[viewControllerA presentViewController:viewControllerB animated:YES completion:NULL];
```

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/175742.gif)

当通过 `presentViewController:animated:completion:` 方式让视图控制器 A 以模态方式呈现视图控制器 B 时，两个视图控制器之间的层次结构是这样的：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/180335.png)



视图控制器 A 被称之为 presenting View Controller。

视图控制器 B 被称之为 presented View Controller。

而 `UIPresentationController` 类在其中充当着协调器的作用，它并不会显示在视图层次结构中，借用网友的一张图表示 `UIPresentationController` 在其中的位置：

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/181245.png)



> 💡 为方便起见，本教程中会把 `UIPresentationController`  命名为「呈现控制器」。

我们需要创建一个继承 `UIPresentationController` 的子类，负责「被呈现」及「负责呈现」的控制器以外的 controller, 比如显示带渐变效果的黑色半透明背景视图，还可以在其中创建带有阴影或者圆角的中间层视图，本教程中会教大家如何在密码输入框的左上角和右上角设置圆角。

 在此步骤中，起码需要重写以下 5 个方法：

1. `- (void)presentationTransitionWillBegin;`， 跳转将要开始时执行。
2. `- (void)presentationTransitionDidEnd:(BOOL)completed;`，跳转已经结束时执行。
3. `- (void)dismissalTransitionWillBegin;`，返回将要开始时执行。
4. `- (void)dismissalTransitionDidEnd:(BOOL)completed;`，返回已经结束时执行。
5. `frameOfPresentedViewInContainerView`，跳转完成后，被呈现视图在容器视图中的位置。



其中，`frameOfPresentedViewInContainerView` 是一个只读属性，用于在过渡动画呈现结束时，设置被呈现的视图在容器视图中的位置。

```objective-c
@property(nonatomic, readonly) CGRect frameOfPresentedViewInContainerView;
```

我们会在子类中实现 Getter 方法，返回被呈现视图在容器视图中的位置。



在该头文件中，我们还需要声明该类遵守并实现 `<UIViewControllerTransitioningDelegate>` 协议。

遵守 `<UIViewControllerTransitioningDelegate>` 协议的作用：告诉控制器，谁是动画主管 (`UIPresentationController`)，哪个类负责开始动画的具体细节、哪个类负责结束动画的具体细节、是否需要实现可交互的转场动画。

这个协议中一共有 5 个可选的实现方法，大致浏览一下：

```objective-c
@protocol UIViewControllerTransitioningDelegate <NSObject>

@optional
// 返回的对象控制 Presented 时的动画 (该类负责开始动画的具体细节)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

// 由返回的控制器控制 dismissed 时的动画 (该类负责结束动画的具体细节)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

// 实现可交互转换动画，呈现动画
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;

// 实现可交互转换动画，dismiss 动画
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;

// 告诉控制器，谁是动画主管(UIPresentationController)，因为此类继承了 UIPresentationController，就返回了 self
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source API_AVAILABLE(ios(8.0));

@end
```



在呈现密码输入框视图时，我们需要在密码输入框和 presenting View Controller 之间显示一个半透明的遮罩层，这个遮罩层视图我们称之为 `dimmingView`，它就可以被添加到我们创建的 `UIPresentationController` 子类对象中。因此，我们会在 `HQLVerticalPresentationController.m` 的类扩展中创建一个属性：

```objective-c
@interface HQLVerticalPresentationController () 
@property (nonatomic, strong) UIView *dimmingView;
@end
```

另外，我们还需要通过一个容器视图来显示密码输入框左上角和右上角的圆角，因此再添加一个带圆角的包装视图：

```objective-c
@interface HQLVerticalPresentationController ()
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *presentationRoundedCornerWrappingView;
@end
```

实现 `UIPresentationController` 子类对象的指定初始化方法：

```objective-c
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
```

对于使用 `UIPresentationController` 子类来自定义呈现控制器时，presented view controller 的 `modalPresentationStyle` 属性必须设置为 `UIModalPresentationCustom`。

在实现文件中，需要重载的几个父类方法如下，几乎每一处代码都有注释说明：

```objective-c
//  这是 presentation controller 在呈现视图之初时首先被调用的方法之一。
//  当这个方法被调用时，containerView 已经在视图层次结构中被创建。
//  但是，presentedView 还没有被检索到。
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
         presentationRoundedCornerView 的高度比 presented view controller 的视图高 CORNER_RADIUS 的值。
         这是因为 cornerRadius 默认被应用于视图的所有角。
         由于该效果只要求对顶部两个角进行圆角处理，我们将视图底部的 CORNER_RADIUS 点调整为位于
         屏幕的底部边缘以下位置。
         */
        UIView *presentationRoundedCornerView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.frameOfPresentedViewInContainerView, UIEdgeInsetsMake(0, 0, -CORNER_RADIUS, 0))];
        presentationRoundedCornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        presentationRoundedCornerView.layer.cornerRadius = CORNER_RADIUS;
        presentationRoundedCornerView.layer.masksToBounds = YES;
        self.presentationRoundedCornerWrappingView = presentationRoundedCornerView;
        
        /**
         为了撤销加在 presentationRoundedCornerView 上的额外高度，
         presentationViewControllerWrapperView 被 CORNER_RADIUS 点插入.
         这也使 presentationViewControllerWrapperView 的边界大小与 frameOfPresentedViewInContainerView 的大小相匹配。
         */
        UIView *presentedViewControllerWrapperView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds, UIEdgeInsetsMake(0, 0, CORNER_RADIUS, 0))];
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

// 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
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

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin
{
    // 获取过渡期协调器以实现退出，这样我们就可以在退出动画的同时，淡化 dimmingView。
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

// 消失过渡完成之后调用，此时应该将视图移除，防止强引用
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
```

你会注意到，我们在 dimmingView 上添加了一个手势识别器，当点击密码输入框上方的半透明视图时，可以实现密码输入框的 dismiss 效果，手势识别器处理程序如下：

```objective-c
//  IBAction for the tap gesture recognizer added to the dimmingView.
//  Dismisses the presented view controller.
//
- (IBAction)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}
```

动态方式实现四个布局方法：

```objective-c
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
    self.presentationRoundedCornerWrappingView.frame = self.frameOfPresentedViewInContainerView;
}
```

我们的 `UIPresentationController` 子类对象还需要遵守并实现 `<UIViewControllerAnimatedTransitioning>` 协议。你当然可以把实现这两个协议的方法通过两个不同的类来实现，分别实现 `UIViewControllerTransitioningDelegate` 协议和 `<UIViewControllerAnimatedTransitioning>` 协议。但这两个协议的方法具有较强的关联性，通常的做法是全都在某一个类内部实现了。

这里我们在`UIPresentationController` 子类对象的扩展中设置让它遵守`<UIViewControllerAnimatedTransitioning>` 协议：

```objective-c
@interface HQLVerticalPresentationController () <UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIView *dimmingView;
@property (nonatomic, strong) UIView *presentationRoundedCornerWrappingView;
@end
```

实现两个动画转换的核心方法：

```objective-c
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
    // 获取源控制器、目标控制器、动画容器 view
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // 获取源控制器、目标控制器的 View，但是注意二者在开始动画，消失动画，身份是不一样的：
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
        
    // 判断是 present 还是 dismiss 动画
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

```



## 创建 UIViewController 子类对象作为 presented View Controller

因为创建的被呈现视图控制器并不是全屏显示的，所以需要用一个指定初始化方法来传递当前视图控制器视图的 `frame` 属性。

```objective-c
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLVerticalPresentedViewController : UIViewController

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
```

在实现文件中，核心代码就是通过 `frame` 属性的值更新被呈现视图控制器的尺寸。

```objective-c
#import "HQLVerticalPresentedViewController.h"
#import <YYKit/YYCGUtilities.h>
#import "HQLVerticalPresentationController.h"

@interface HQLVerticalPresentedViewController ()
@property (nonatomic, assign, readwrite) CGRect frame;
@end

@implementation HQLVerticalPresentedViewController

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _frame = frame;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    self.preferredContentSize = _frame.size;
}

#pragma mark - Private

//| ----------------------------------------------------------------------------
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    // When the current trait collection changes (e.g. the device rotates),
    // update the preferredContentSize.
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

//| ----------------------------------------------------------------------------
//! Updates the receiver's preferredContentSize based on the verticalSizeClass
//! of the provided traitCollection.
//
- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact ? 270 : 420);
}

@end
```



其实，创建完以上两个视图控制器之后，我们就可以以半模态视图的样式来呈现视图了，具体使用步骤：

1. 初始化 `HQLVerticalPresentedViewController` 或其子类实例：

   ```objective-c
   HQLVerticalPresentedViewController *presentationViewController = [[HQLVerticalPresentedViewController alloc] init];
   ```

2. 初始化 `HQLPresentationController` 实例：

   ```objective-c
   HQLVerticalPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
   
   presentationController = [[HQLVerticalPresentationController alloc] initWithPresentedViewController:presentationViewController presentingViewController:self];
   ```

3. 设置 `UIViewControllerTransitioningDelegate`：

   ```objective-c
   presentationViewController.transitioningDelegate = presentationController;
   ```

4. 模态呈现：

   ```objective-c
   [self presentViewController:presentationViewController animated:YES completion:NULL];
   ```



## 在 `HQLVerticalPresentedViewController` 子类对象中添加你想要呈现的视图

我们可以通过子类化 `HQLVerticalPresentedViewController` 的方式，在该视图控制器中添加密码输入框视图，当中包括了一些密码输入框相关的视图元素。

密码输入框视图元素的实现我大概参考了之前的实现，当然也略有优化和修改。

之前的实现文章：[密码输入框：HQLPasswordViewDemo](https://www.jianshu.com/p/7aa9c9d2b366)

所以，有了密码输入框视图 `HQLPasswordsView` 之后，我们直接创建一个`HQLVerticalPresentedViewController`  的子类对象，暂且命名为 `HQLPasswordViewController` 好了：

```objective-c
#import "HQLVerticalPresentedViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQLPasswordViewController : HQLVerticalPresentedViewController

@end

NS_ASSUME_NONNULL_END
```

实现代码中，把密码输入框视图 `HQLPasswordsView` 作为该视图控制器的属性引入即可，然后通过 Block 方式实现了交互回调：

```objective-c
#import "HQLPasswordViewController.h"
#import "HQLPasswordsView.h"

@interface HQLPasswordViewController ()
@property (nonatomic, strong) HQLPasswordsView *passwordView;
@end

@implementation HQLPasswordViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.passwordView];
    [self configurePasswordView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 自动弹出键盘
    [self.passwordView.pwdTextField becomeFirstResponder];
}

#pragma mark - Custom Accessors

- (HQLPasswordsView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[HQLPasswordsView alloc] initWithFrame:self.view.bounds];
    }
    return _passwordView;
}


#pragma mark - Private

- (void)configurePasswordView {
    __weak __typeof(self)weakSelf = self;
    
    // MARK: 关闭按钮
    self.passwordView.closeBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
    };

    // MARK: 忘记密码
    self.passwordView.forgetPasswordBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:NULL];
        
        // 执行找回密码流程
    };
    
    // MARK: 输入所有密码，发起网络请求，校验密码
    self.passwordView.finishBlock = ^(NSString *inputPassword) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSLog(@"password = %@",inputPassword);
        
        // 通过 GCD 模拟网络请求
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                                delayInSeconds *NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [strongSelf.passwordView requestComplete:YES message:@"支付成功"];
        });
    };
}

@end
```

当处理密码输入这种一次性交互时，通过 Block 块的方式处理 presenting view controller 和 presented view controller 之间的数据交互是可用的方式之一。

如果要处理列表视图或者集合视图中某个 cell 元素的点击处理事件，你也可以通过 Delegate 的方式实现这两者之间的交互。



## 将密码输入框视图控制器作为半模态视图控制器呈现

在你所需要的业务场景中，呈现密码输入框视图控制器：

```objective-c
- (IBAction)presentPasswordViewController:(id)sender {
    
    // 1.初始化 HQLPresentationViewController 实例
    HQLPasswordViewController *passwordViewController = [[HQLPasswordViewController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 455)];
    
    // 2.初始化 HQLPresentationController 实例
    HQLVerticalPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[HQLVerticalPresentationController alloc] initWithPresentedViewController:passwordViewController presentingViewController:self];
    
    // 3.设置 UIViewControllerTransitioningDelegate
    passwordViewController.transitioningDelegate = presentationController;

    // 4.模态呈现
    [self presentViewController:passwordViewController animated:YES completion:NULL];
}
```



🎉🎉🎉 效果就是你在文章最开始看见的样子。

千呼万唤始出来，源码也不能少，该示例代码可以在 [iOS-Samples/UIPresentationController相关示例/UIPresentationController/HQLPasswordView](https://github.com/Andy0570/iOS-Samples/tree/master/UIPresentationController%20%E7%9B%B8%E5%85%B3%E7%A4%BA%E4%BE%8B/UIPresentationController/UIPresentationController/HQLPasswordView) 中找到。可能是藏得比较深了，为了避免 iOS Demo 过多，并且分散在 GitHub 的多个仓库下，使得 repositories 变得臃肿，而且也造成了项目污染，所以我把它们都归档在一个仓库下了。



Anyway，Have Fun！