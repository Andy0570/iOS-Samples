# HQLRiseTabBarDemo
实现一个仿淘宝「闲鱼」的 TabBar 标签页效果



**HQLRiseTabBarDemo** 示例是原生方式实现的效果。


# 一、官方 UI 示例

某鱼主页截屏：

![](https://upload-images.jianshu.io/upload_images/2648731-72f2acd767a501be.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)

注意查看 TabBar 中间的「发布」按钮，它是凸出显示的，而且比其他 `UITabBarItem` 都大很多，那么我们如何实现这个效果呢？

# 二、原理解析

![](https://upload-images.jianshu.io/upload_images/2648731-4928e573deb0b7ae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)

在 UITabBar 中：

* 「首页」、「同城」、「消息」、「我的」这四个 `UITabBarItem` 是正常的原生实现方式。
* 「发布」按钮是在空白的占位空间上“贴”上去的一个 `UIButton` 按钮。

# 三、实现

创建一个 `UITabBarController` 的子类对象，在初始化方法中添加所需的视图控制器，这里我把它封装成两个方法：

```Objective-C
/// 将要添加到 TabBar 中的 UIViewController 用 UINavigationController 封装后再添加
- (void)setupViewControllers {
    // 首页
    UIViewController *homeVC = [self renderTabBarItem:[[HomeViewController alloc] init]
                                                title:@"首页"
                                           imageNamed:@"home_normal"
                                   selectedImageNamed:@"home_highlight"];
    HQLNavigationController *homeNC = [[HQLNavigationController alloc] initWithRootViewController:homeVC];
    
    // 同城
    UIViewController *myCityVC = [self renderTabBarItem:[[MyCityViewController alloc] init]
                                                  title:@"同城"
                                             imageNamed:@"mycity_normal"
                                     selectedImageNamed:@"mycity_highlight"];
    HQLNavigationController *myCityNC = [[HQLNavigationController alloc] initWithRootViewController:myCityVC];
    
    // 消息
    UIViewController *messageVC = [self renderTabBarItem:[[MessageViewController alloc] init]
                                                   title:@"消息"
                                              imageNamed:@"message_normal"
                                      selectedImageNamed:@"message_highlight"];
    HQLNavigationController *messageNC = [[HQLNavigationController alloc] initWithRootViewController:messageVC];
    
    // 我的
    UIViewController *accountVC = [self renderTabBarItem:[[AccountViewController alloc] init]
                                                   title:@"我的"
                                              imageNamed:@"account_normal"
                                      selectedImageNamed:@"account_highlight"];
    HQLNavigationController *accountNC = [[HQLNavigationController alloc] initWithRootViewController:accountVC];
    
    // 占位视图控制器
    UIViewController *placeHolderVC = [[UIViewController alloc] init];
    placeHolderVC.tabBarItem.enabled = NO;
    placeHolderVC.tabBarItem.title = nil;
    
    self.viewControllers = @[homeNC, myCityNC, placeHolderVC, messageNC, accountNC];
}

- (UIViewController *)renderTabBarItem:(UIViewController *)viewController
                                 title:(NSString *)title
                            imageNamed:(NSString *)normalImgName
                    selectedImageNamed:(NSString *)selectedImgName {
    
    viewController.title = title;
    
    UIImage *normalImage = [[UIImage imageNamed:normalImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selectedImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                              image:normalImage
                                                      selectedImage:selectedImage];
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}
                                             forState:UIControlStateSelected];
    return viewController;
}
```
注：中间的一个 `UITabBarItem` 上放的是一个空的 `UIViewController` 实例，而且我们把它对应的 tabBarItem 隐藏起来了，它仅仅起到了占位的效果。

下面的方法就是添加「发布」按钮的实现代码：

```Objective-C  
- (void)configTabBarAppearance {
    
    // 去掉TabBar上部的黑色线条,设置TabBar透明背景
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithLYColor:[UIColor clearColor]]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
        
//    UIView *topLineView = [[UIView alloc] init];
//    topLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tabBar.bounds), 1);
//    topLineView.backgroundColor = [UIColor colorWithWhite:0.966 alpha:1.000];
//    [self.tabBar addSubview:topLineView];
    
    // 设置中间的 tabBarItem
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.tabBar.bounds.size.width - 55) / 2, self.tabBar.bounds.size.height - 88, 55, 100)];
    // set button image
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 38 * 38
    [button setImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
    // set button title
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:10.0 weight:UIFontWeightBold];
    // adjust position
    [button hql_verticalCenterImageAndTitle:2.0];
    [button addTarget:self
               action:@selector(middleButtonDidClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:button];
    [self.tabBar bringSubviewToFront:button];
}

#pragma mark - IBActions

- (void)middleButtonDidClicked:(id)sender {
    // 实现「发布」按钮点击功能
}
```

源码：[HQLRiseTabBarDemo](https://github.com/Andy0570/HQLRiseTabBarDemo)


# 参考

* [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController)
* [LLRiseTabBar-iOS](https://github.com/NoCodeNoWife/LLRiseTabBar-iOS)
* [LLRiseTabBar-iOS](https://github.com/lianleven/LLRiseTabBar-iOS)
* [AxcAE_TabBar](https://github.com/axclogo/AxcAE_TabBar)
* [animated-tab-bar](https://github.com/Ramotion/animated-tab-bar) Swift