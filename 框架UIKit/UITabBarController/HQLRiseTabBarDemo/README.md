# HQLRiseTabBarDemo
本 Demo 通过原生方式实现了一个仿「闲鱼」的 TabBar 标签页效果。

## 一、官方 UI 示例

某鱼主页截屏：

![](https://upload-images.jianshu.io/upload_images/2648731-72f2acd767a501be.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)

注意查看 TabBar 中间的「发布」按钮，它是凸出显示的，而且比其他 `UITabBarItem` 都大很多，那么我们如何实现这个效果呢？


## 二、原理解析

![](https://upload-images.jianshu.io/upload_images/2648731-4928e573deb0b7ae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)

在 UITabBar 中：

* 「首页」、「同城」、「消息」、「我的」这四个 `UITabBarItem` 是正常的原生实现方式。
* 「发布」按钮是在空白的占位空间上“贴”上去的一个 `UIButton` 按钮。


## 三、实现

创建一个 `UITabBarController` 的子类对象，在初始化方法中添加所需的视图控制器，这里我把它封装成两个方法：

```Objective-C
/// 将要添加到 TabBar 中的 UIViewController 用 UINavigationController 封装后再添加
- (void)setupViewControllers {
    UIColor *normalTitleColor = [UIColor grayColor];
    UIColor *selectedTitleColor = [UIColor blackColor];
    
    // 修复 tabBar 选中时颜色变蓝
    self.tabBar.tintColor = selectedTitleColor;

    // 首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    HQLTabBarItem *homeTabBarItem = [[HQLTabBarItem alloc] initWithNormalTitle:@"首页" selectedTitle:@"首页" normalTitleColor:normalTitleColor selectedTitleColor:selectedTitleColor normalImageName:@"home_normal" selectedImageName:@"home_highlight"];
    [self configController:homeVC withTabBarItem:homeTabBarItem];
    HQLNavigationController *homeNC = [[HQLNavigationController alloc] initWithRootViewController:homeVC];
    
    // 同城
    MyCityViewController *myCityVC = [[MyCityViewController alloc] init];
    HQLTabBarItem *myCityTabBarItem = [[HQLTabBarItem alloc] initWithNormalTitle:@"同城" selectedTitle:@"同城" normalTitleColor:normalTitleColor selectedTitleColor:selectedTitleColor normalImageName:@"mycity_normal" selectedImageName:@"mycity_highlight"];
    [self configController:myCityVC withTabBarItem:myCityTabBarItem];
    HQLNavigationController *myCityNC = [[HQLNavigationController alloc] initWithRootViewController:myCityVC];
    
    // 消息
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    HQLTabBarItem *messageTabBarItem = [[HQLTabBarItem alloc] initWithNormalTitle:@"消息" selectedTitle:@"消息" normalTitleColor:normalTitleColor selectedTitleColor:selectedTitleColor normalImageName:@"message_normal" selectedImageName:@"message_highlight"];
    [self configController:messageVC withTabBarItem:messageTabBarItem];
    HQLNavigationController *messageNC = [[HQLNavigationController alloc] initWithRootViewController:messageVC];
    
    // 我的
    AccountViewController *accountVC = [[AccountViewController alloc] init];
    HQLTabBarItem *accountTabBarItem = [[HQLTabBarItem alloc] initWithNormalTitle:@"我的" selectedTitle:@"消息" normalTitleColor:normalTitleColor selectedTitleColor:selectedTitleColor normalImageName:@"account_normal" selectedImageName:@"account_highlight"];
    [self configController:accountVC withTabBarItem:accountTabBarItem];
    HQLNavigationController *accountNC = [[HQLNavigationController alloc] initWithRootViewController:accountVC];
    
    // !!!: 占位视图控制器
    UIViewController *placeHolderVC = [[UIViewController alloc] init];
    placeHolderVC.tabBarItem.enabled = NO;
    placeHolderVC.tabBarItem.title = nil;
    
    self.viewControllers = @[homeNC, myCityNC, placeHolderVC, messageNC, accountNC];
}

- (void)configController:(UIViewController *)controller withTabBarItem:(HQLTabBarItem *)tabBarItem {
    // 设置导航栏标题为 TabBar 标题
    controller.title = tabBarItem.normalTitle;
    
    // 设置 tabBar 标题、图片
    UIImage *normalImage = [[UIImage imageNamed:tabBarItem.normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:tabBarItem.selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem = [[UITabBarItem alloc] initWithTitle:tabBarItem.normalTitle image:normalImage selectedImage:selectedImage];
    
    // 设置 tabBar 标题默认颜色：灰色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: tabBarItem.normalTitleColor} forState:UIControlStateNormal];
    
    // 设置 tabBar 标题被选中的颜色：黑色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: tabBarItem.selectedTitleColor} forState:UIControlStateSelected];
}
```
注：中间的一个 `UITabBarItem` 上放的是一个空的 `UIViewController` 实例，而且我们把它对应的 tabBarItem 隐藏起来了，它仅仅起到了占位的效果。

另外，`HQLTabBarItem` 仅仅是一个基于 `NSObject` 的模型类，用于保存 `UITabBarItem` 视图所需的配置信息。

```Objective-C
//  HQLTabBarItem.h
@interface HQLTabBarItem : NSObject

@property (nonatomic, readonly, copy, nonnull) NSString *normalTitle;
@property (nonatomic, readonly, copy, nonnull) NSString *selectedTitle;

@property (nonatomic, readonly, strong, nonnull) UIColor *normalTitleColor;
@property (nonatomic, readonly, strong, nonnull) UIColor *selectedTitleColor;

@property (nonatomic, readonly, copy, nonnull) NSString *normalImageName;
@property (nonatomic, readonly, copy, nonnull) NSString *selectedImageName;

@property (nonatomic, copy) NSString *markText;
@property (nonatomic, assign, getter=shouldShowMarkText) BOOL showMarkText;
@property (nonatomic, copy) NSString *tabIdentifier;

- (instancetype)initWithNormalTitle:(NSString *)normalTitle
                      selectedTitle:(NSString *)selectedTitle
                   normalTitleColor:(UIColor *)normalTitleColor
                 selectedTitleColor:(UIColor *)selectedTitleColor
                    normalImageName:(NSString *)normalImageName
                  selectedImageName:(NSString *)selectedImageName;

@end
  
//  HQLTabBarItem.m
#import "HQLTabBarItem.h"

@interface HQLTabBarItem ()

@property (nonatomic, readwrite, copy, nonnull) NSString *normalTitle;
@property (nonatomic, readwrite, copy, nonnull) NSString *selectedTitle;

@property (nonatomic, readwrite, strong, nonnull) UIColor *normalTitleColor;
@property (nonatomic, readwrite, strong, nonnull) UIColor *selectedTitleColor;

@property (nonatomic, readwrite, copy, nonnull) NSString *normalImageName;
@property (nonatomic, readwrite, copy, nonnull) NSString *selectedImageName;

@end

@implementation HQLTabBarItem

- (instancetype)initWithNormalTitle:(NSString *)normalTitle
                      selectedTitle:(NSString *)selectedTitle
                   normalTitleColor:(UIColor *)normalTitleColor
                 selectedTitleColor:(UIColor *)selectedTitleColor
                    normalImageName:(NSString *)normalImageName
                  selectedImageName:(NSString *)selectedImageName {
    self = [super init];
    if (!self) { return nil; }
    
    self.normalTitle = normalTitle;
    self.selectedTitle = selectedTitle;
    self.normalTitleColor = normalTitleColor;
    self.selectedTitleColor = selectedTitleColor;
    self.normalImageName = normalImageName;
    self.selectedImageName = selectedImageName;
    
    return self;
}

@end
```

编译并运行项目，应用页面看起来是这样的：

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gmuc698minj30g00hywfg.jpg)

下面的方法就是添加「发布」按钮的实现代码：

```Objective-C  
- (void)configTabBarAppearance {
    
    // 去掉TabBar上部的黑色线条,设置TabBar透明背景
//    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithLYColor:[UIColor clearColor]]];
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
        
//    UIView *topLineView = [[UIView alloc] init];
//    topLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tabBar.bounds), 1);
//    topLineView.backgroundColor = [UIColor colorWithWhite:0.966 alpha:1.000];
//    [self.tabBar addSubview:topLineView];
    
    // MARK: 设置中间的 tabBarItem
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
    
    // 将自定义按钮添加到 tabBar
    [self.tabBar addSubview:button];
    [self.tabBar bringSubviewToFront:button];
}

#pragma mark - IBActions

- (void)middleButtonDidClicked:(id)sender {
    // 实现「发布」按钮点击功能
}
```

编译并运行应用，页面样式应该是这样的：

![](https://tva1.sinaimg.cn/large/008eGmZEgy1gmucc1y5e9j30g00ghq2x.jpg)



[GitHub 源码](https://github.com/Andy0570/iOS-Samples/tree/master/Framework_UIKit/UITabBarController/HQLRiseTabBarDemo)



## 参考

* [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController)
* [LLRiseTabBar-iOS](https://github.com/NoCodeNoWife/LLRiseTabBar-iOS)
* [LLRiseTabBar-iOS](https://github.com/lianleven/LLRiseTabBar-iOS)
* [AxcAE_TabBar](https://github.com/axclogo/AxcAE_TabBar)
* [animated-tab-bar](https://github.com/Ramotion/animated-tab-bar) Swift