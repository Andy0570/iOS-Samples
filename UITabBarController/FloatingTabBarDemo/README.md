# FloatingTabBarDemo

iOS 自定义悬浮 TabBar，模仿马蜂窝。

<img src="https://static01.imgkr.com/temp/fcb97e7fc61448999e801b4473f1fc89.PNG" style="zoom:50%;" />


## 依赖的开源框架

* [Pop 动画框架@Facebook](https://github.com/facebookarchive/pop)
* [Masonry](https://github.com/SnapKit/Masonry)
* [JKCategories](https://github.com/shaojiankui/JKCategories)
* [YYKit](https://github.com/ibireme/YYKit)
* [Chameleon](https://github.com/viccsmind/Chameleon)
* [JXCategoryView](https://github.com/pujiaxin33/JXCategoryView)，分页菜单功能
* [JXPagingView](https://github.com/pujiaxin33/JXPagingView)


## 功能特性

* 通过浮动 TabBar 实现对 `UITabBarController` 中视图控制器的切换；
* 点击浮动 TabBar  按钮时，为按钮增加 Spring 动画抖动效果 ；
* 上拉 `UIScrollView` 页面时，缩小浮动 TabBar；
* 下拉 `UIScrollView` 页面时，展开浮动 TabBar；
* 用户手势停止一段时间后，自动展开浮动 TabBar；
* 通过点击状态栏返回到 `UIScrollView` 顶部时，自动展开浮动 TabBar；


## 实现原理

将 `HQLFloatingTabBar` 添加到应用程序窗口（`UIWindow`）上，并通过**单例设计模式**管理。

```objectivec
- (void)show {
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
    [mainWindow addSubview:self];
}
```

隐藏 `UITabBarController` 的底部 TabBar，点击自定义浮动 TabBar 按钮时，通过代码方式实现 `UITabBarController` 中的视图控制器页面的切换。

```objectivec
- (void)selectBarButtonAtIndex:(NSUInteger)index {
    self.tabBarController.selectedIndex = index;
}
```

包含 `UIScrollView` 的页面遵守 `<UIScrollViewDelegate>` 协议，通过代理方法中页面滚动状态，实现浮动 TabBar 的展开和收缩动画。

```objectivec
#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint velocityPoint = [scrollView.panGestureRecognizer velocityInView:scrollView];
    if (velocityPoint.y < -5) {
        // 手指从下往上滑，浏览更多内容，收起悬浮按钮
        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] compressFloatingTabBar];
    } else if (velocityPoint.y > 5) {
        // 手指从上往下滑，返回顶部，还原悬浮按钮
        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] stretchFloatingTabBar];
    }
}

// 该方法在「用户停止拖拽时」调用
// decelerate（减速） 为 NO，表示 scrollView 滑动是立即停止的。
// decelerate（减速） 为 YES，表示手指停止拖拽后 scrollView 还在自动继续减速（动画缓慢停止）。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    [self delayStretchFloatingTabBar];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self delayStretchFloatingTabBar];
}

// 该方法在 scrollView 已经滑动到顶部时调用
// 仅当通过点击状态栏让 scrollView 滑动到顶部才调用
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    // 滑动到顶部时，还原悬浮框
    [[HQLFloatingTabBarManager sharedFloatingTabBarManager] stretchFloatingTabBar];
}

- (void)delayStretchFloatingTabBar {
    double delayInSeconds = 2.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 停止滑动 3s 后，还原悬浮框
        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] stretchFloatingTabBar];
    });
}
```

浮动 TabBar 的展开和收缩动画通过 [Pop 动画框架@Facebook](https://github.com/facebookarchive/pop) 实现。

展开动画：

```objectivec
- (void)executeStretchAnimation {
    [self pop_removeAllAnimations];
    
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBounds];
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 50)];
    basicAnimation.duration = 0.25;
    [self pop_addAnimation:basicAnimation forKey:@"pop_tabBar_size"];
        
    POPBasicAnimation *colorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    colorAnimation.toValue = [UIColor colorWithWhite:1.0 alpha:0.8];
    [self pop_addAnimation:colorAnimation forKey:@"pop_tabBar_color"];
}
```


收缩动画：

```objectivec
- (void)executeCompressAnimation {
    [self pop_removeAllAnimations];
    
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBounds];
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    basicAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    basicAnimation.duration = 0.25;
    [self pop_addAnimation:basicAnimation forKey:@"pop_tabBar_size"];
    
    POPBasicAnimation *colorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    colorAnimation.toValue = [UIColor colorWithRed:84/255.0f green:202/255.0f blue:195/255.0f alpha:1.0];
    colorAnimation.duration = 0.25;
    [self pop_addAnimation:colorAnimation forKey:@"pop_tabBar_color"];
}
```



## 使用许可

本项目基于 [MIT](https://opensource.org/licenses/MIT) 许可协议，详情请参见 [LICENSE](https://github.com/Andy0570/iOS-Samples/blob/master/LICENSE)。