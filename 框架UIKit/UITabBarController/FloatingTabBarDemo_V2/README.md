在浮动 TabBar 第一版 Demo 中，我使用 `UITabBarController` 作为根视图控制器，并在 `HQLBaseTabBarController` 实例初始化时就设置 `self.tabBar.hidden = YES` 以隐藏底部标签栏：

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tabBarController = [[HQLBaseTabBarController alloc] init];
    self.tabBarController.tabBar.hidden = YES;  // 隐藏底部 TabBar
    self.window.rootViewController = self.tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self addFloatingTabBar];
    return YES;
}
```

使用 `UITabBarController` 作为根视图控制器时，应用的视图控制器层级架构是这样的：

```objective-c
 HQLBaseTabBarController - HQLBaseNavigationController - MainViewController   // 首页
                         - HQLBaseNavigationController - SecondViewController // 次页
```

但是在实际使用时，会发生通过 `UINavigationController` push 到下一个视图控制器页面时，底部会有一个 TabBar 高度的留白，（也可能是 JXPagingView 框架的页面适配问题），总而言之，`UITabBarController` 、 `UINavigationController` 结合部分第三方页面框架使用，会发生不少预料之外的 Bug！

遍历解决方案无果后，我尝试创建自定义协调视图控制器，作为根视图控制器的容器视图，以下是参考的实现原理：

- [视图控制器的作用](http://static.kancloud.cn/god-is-coder/jishuwendang/505955)
- [iOS 开发之视图控制器 (UIViewController)](https://liuzhichao.com/p/1408.html)
- [自定义容器视图控制器总结](https://zhuanlan.zhihu.com/p/33106649)

使用自定义容器视图控制器（本示例中为 `HQLCoordinatorViewController`）后，应用的视图控制器层级结构是这样的：

```objective-c
 HQLCoordinatorViewController - HQLBaseNavigationController - MainViewController   // 首页
                              - HQLBaseNavigationController - SecondViewController // 次页
```

在容器视图控制器中，显示/隐藏其他视图控制器的视图主要原理为以下两个方法：

```objective-c
/// 显示被包含的视图控制器
/// @param content 要显示的视图控制器
- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    content.view.frame = self.view.bounds;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}

/// 隐藏被包含的视图控制器
/// @param content 要隐藏的视图控制器
- (void)hideContentController:(UIViewController *)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}
```

想要模仿类似点击 `UITabBarController` 底部的标签页，实现在两个视图控制器之间的切换效果：

```objective-c
- (void) performTransitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController {
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    [self.view addSubview:toView];
    
    [UIView animateWithDuration:0.25 animations:^{

        toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        fromView.frame = CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight);
        [self.view layoutIfNeeded];

        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] showFloatingTabBar];
    } completion:^(BOOL finished) {
        [toViewController didMoveToParentViewController:self];
        
        [fromView removeFromSuperview];
        [fromViewController removeFromParentViewController];
    }];
}
```

本示例中，我使用了 `<POP>` 框架实现切换动画：

```objective-c
/// 切换视图控制器，从当前视图控制器页面切换到要显示的视图控制器页面
/// @param fromViewController 当前视图控制器
/// @param toViewController 要显示的视图控制器
- (void) performTransitionFromViewController:(UIViewController*)fromViewController toViewController:(UIViewController*)toViewController {
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    UIView *toView = toViewController.view;
    UIView *fromView = fromViewController.view;
    [self.view addSubview:toView];

    POPBasicAnimation *fromViewAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    fromViewAnimation.duration = 0.25;
    
    POPBasicAnimation *toViewAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    toViewAnimation.duration = 0.25;
    
    if (fromViewController == self.mainNavigationViewController) {
        fromViewAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];

        toViewAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        toViewAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    } else {
        fromViewAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        
        toViewAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(-kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        toViewAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    
    fromViewAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [fromView removeFromSuperview];
        [fromViewController removeFromParentViewController];
    };
    [fromView pop_addAnimation:fromViewAnimation forKey:@"FromView_POPViewFrame"];
    
    toViewAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [toViewController didMoveToParentViewController:self];
    };
    [toView pop_addAnimation:toViewAnimation forKey:@"ToView_POPViewFrame"];
}
```

