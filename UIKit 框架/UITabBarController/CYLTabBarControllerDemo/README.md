# CYLTabBarController

GitHub: [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController)

Star: 5.8k



官方描述：

> 【中国特色 TabBar】一行代码实现 Lottie 动画 TabBar，支持中间带 + 号的 TabBar 样式，自带红点角标，支持动态刷新。【iOS13 & Dark Mode & iPhone XS MAX supported】。



## 前言

首先：不仅仅是一行代码！

官方声称的 "一行代码实现 Lottie 动画 TabBar" 其实有虚晃一枪的嫌疑，让你听起来误以为用**一行代码**就可以实现淘宝「闲鱼」那种既带 ➕ 号按钮又带 Lottie 动画的 TabBar 了。其实折腾下来还是要写个几百行代码的。

所谓的 "一行代码实现 Lottie 动画”，其实就是配置方法里面再加一个 key 值为  `CYLTabBarLottieURL` 的属性，它的值是一个 `NSURL` 链接，指向你项目中描述 Lottie 动画的 JSON 文件。你还是需要自己提前准备好 Lottie 的 JSON 文件的，所以说，所谓的一行代码就是，当涉及到 Lottie 动画时，你给系统传一个带 Lottie 动画的 URL 文件（既然“一行代码”是这个意思的话，我是不是可以说一行代码实现一个全套 Google 搜索引擎功能呢？打开一个 google.com 的 HTML 5 页面不就实现了吗？）。

另外，一看见 **CYLTabBarController** 这个框架是国人写的，而且 README 文档是中文的，真的是喜极而泣😹，让我误以为花个 5 分钟便可以从入门到精通，最终折腾了好几天，下载了好几个 Demo 才算弄明白。

鉴于官方 README.md 文档的含糊不清，与配套 Demo 写法上也存在很大的出入，还是让一开始初入了解该框架的同学造成了很大的困扰。

接下来，我会通过实现一个模仿「闲鱼」TabBar 动画的 Demo 来让大家重新了解它。



## 开始使用

### 准备：新建 Xcode 项目

在 Xcode 11 环境下新建一个 **Single View App** 项目，打开这个新的项目，可以看到系统除了会自动生成 `AppDelegate` 文件外，还会自动生成一个名为 `SceneDelegate` 的类文件。

![项目目录](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/100356.png)

⚠️  `SceneDelegate`  是 iOS 13 下的新特性，查看 [WWDC 2019: Optimizing App Launch](https://developer.apple.com/videos/play/wwdc2019/423/) 可以知道这到底是啥，但是 **CYLTabBarController** 还未适配该特性（截止 1.28.3 版本），基于 `SceneDelegate` 集成该框架应用会崩溃！所以我们要先把 `SceneDelegate` 特性删除才行。

步骤：

1. 首先打开 `Info.plist` 文件，找到下面这两个属性并删除。 

![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/100858.png)

2. 删除 `SceneDelegate` 类文件，其实可删可不删，但既然我们用不到就删了吧。
3. 修改 `AppDelegate.h` 文件，加上 `UIWindow` 属性。

```objective-c
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end
```

4. 修改 `AppDelegate.m` 文件，设置 `UIWindow`  设置主窗口，并**删除多余的 <UISceneSession> 代理协议**。

```objc
#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 设置根视图控制器
    ViewController *controller = [[ViewController alloc] init];
    // 窗口根视图控制器
    self.window.rootViewController = controller;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 下面多余的代码请删除

@end
```

运行项目，无报错则继续往下。



### 第一步：使用 CocoaPods 导入 CYLTabBarController

可以很良心的说，README.md 文档中在 [第一步使用 CocoaPods 导入 CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController#第一步使用cocoapods导入cyltabbarcontroller) 一章算是描述地最详尽的了，它居然还教你如何安装 CocoaPods，堪比 CocoaPods 环境搭建教程了。

但是，有一点需要提醒的是，安装 CocoaPods 请勿使用  `sudo gem install cocoapods` 这个命令，如果运行该命令提示存在权限问题：

```bash
# 错误示例
$ sudo gem install cocoapods
Password:
Fetching cocoapods-1.8.4.gem
Fetching cocoapods-core-1.8.4.gem
Successfully installed cocoapods-core-1.8.4
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /usr/bin directory.
# Mac OS 系统升级之后，系统把 /usr/bin 目录的写入权限禁用了，因此我们需要指定安装到别的目录下。

# 正确示例，需要安装 cocoapods 到指定目录下
$ sudo gem install cocoapods -n /usr/local/bin
Successfully installed cocoapods-1.8.4
Parsing documentation for cocoapods-1.8.4
Installing ri documentation for cocoapods-1.8.4
Done installing documentation for cocoapods after 2 seconds
1 gem installed
```

另外，Podfile 示例文件如下：

```bash
# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'CYLTabBarControllerDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for CYLTabBarControllerDemo
  pod 'CYLTabBarController', '~> 1.28.3'        # 默认不依赖Lottie
  pod 'CYLTabBarController/Lottie', '~> 1.28.1' # 依赖Lottie库
  pod 'ChameleonFramework'                      # 颜色框架
  pod 'YYKit'                                   # 会用到几个辅助方法

end
```



### 第二步：新建 AppDelegate 分类文件，初始化并设置 CYLTabBarController 

 如果你查看 CYLTabBarController 框架的 README.md 文档，作者会让你把很多配置方法写在 `AppDelegate` 这个类中。

但实际应用场景中，有很多配置方法都要写在这个文件里面，比如日志框架的配置、推送通知框架、第三方支付回调配置...还有一大堆工具类配置。

所以我习惯上会把不同的配置文件单独写在各自的分类（Category）中。

具体原因可以去看看《Effective Objective-C 2.0 编写高质量 iOS 与 OS X 代码的 52 个有效方法 》一书中的第 24 条建议。

因此，我们需要新建一个 `AppDelegate` 分类文件，然后把所有与初始化 CYLTabBarController 框架相关的代码都写在 `AppDelegate+CYLTabBar` 文件里面，保持代码整洁，方便修改。

1. 新建一个  `AppDelegate`  分类文件。

   点击 Xcode 导航栏 — File — New — File...— 选择 iOS Source 列表下的「Objective-C File」，新建文件类型和文件名如下：

   ![](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/025012.png)

2. 在 Assets.xcassets 资产库中导入你所需要的图片文件。

3. 在分类中新建一个方法，用于配置主窗口：

```objective-c
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/// 这是 AppDelegate 的分类，用于配置 CYLTabBarController
@interface AppDelegate (CYLTabBar)

/// 配置主窗口
- (void)hql_configureForTabBarController;

@end

NS_ASSUME_NONNULL_END
```

然后我们在 .m 文件中实现它，设置 `CYLTabBarController` 的两个数组：控制器数组和配置 tabBar 外观样式的属性数组：

```objective-c
@implementation AppDelegate (CYLTabBar)

#pragma mark - Public

- (void)hql_configureForTabBarController {
    // 设置主窗口，并设置根视图控制器
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // 初始化 CYLTabBarController 对象
    CYLTabBarController *tabBarController =
        [CYLTabBarController tabBarControllerWithViewControllers:[self viewControllers]
                                           tabBarItemsAttributes:[self tabBarItemsAttributes]];
    // 设置遵守委托协议
    tabBarController.delegate = self;
    // 将 CYLTabBarController 设置为 window 的 RootViewController
    self.window.rootViewController = tabBarController;
}

#pragma mark - Private

/// 控制器数组
- (NSArray *)viewControllers {
    // 首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.navigationItem.title = @"首页";
    CYLBaseNavigationController *homeNC = [[CYLBaseNavigationController alloc] initWithRootViewController:homeVC];
    [homeNC cyl_setHideNavigationBarSeparator:YES];
    
    // 同城
    MyCityViewController *myCityVC = [[MyCityViewController alloc] init];
    myCityVC.navigationItem.title = @"同城";
    CYLBaseNavigationController *myCityNC = [[CYLBaseNavigationController alloc] initWithRootViewController:myCityVC];
    [myCityNC cyl_setHideNavigationBarSeparator:YES];
    
    // 消息
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    messageVC.navigationItem.title = @"消息";
    CYLBaseNavigationController *messageNC = [[CYLBaseNavigationController alloc] initWithRootViewController:messageVC];
    [messageNC cyl_setHideNavigationBarSeparator:YES];
    
    // 我的
    AccountViewController *accountVC = [[AccountViewController alloc] init];
    accountVC.navigationItem.title = @"我的";
    CYLBaseNavigationController *accountNC = [[CYLBaseNavigationController alloc] initWithRootViewController:accountVC];
    [accountNC cyl_setHideNavigationBarSeparator:YES];
    
    NSArray *viewControllersArray = @[homeNC, myCityNC, messageNC, accountNC];
    return viewControllersArray;
}

/// tabBar 属性数组
- (NSArray *)tabBarItemsAttributes {
    NSDictionary *homeTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"首页",
        CYLTabBarItemImage: @"home_normal",
        CYLTabBarItemSelectedImage: @"home_highlight",
    };
    NSDictionary *myCityTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"同城",
        CYLTabBarItemImage: @"mycity_normal",
        CYLTabBarItemSelectedImage: @"mycity_highlight",
    };
    NSDictionary *messageTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"消息",
        CYLTabBarItemImage: @"message_normal",
        CYLTabBarItemSelectedImage: @"message_highlight",
    };
    NSDictionary *accountTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"我的",
        CYLTabBarItemImage: @"account_normal",
        CYLTabBarItemSelectedImage: @"account_highlight",
    };

    NSArray *tabBarItemsAttributes = @[
        homeTabBarItemsAttributes,
        myCityTabBarItemsAttributes,
        messageTabBarItemsAttributes,
        accountTabBarItemsAttributes
    ];
    return tabBarItemsAttributes;
}

@end
```

4. 最后，我们回到 `AppDelegate.m` 文件，导入上一步新建的分类头文件 :

   ```objective-c
   #import "AppDelegate+CYLTabBar.h"
   ```

5. 然后一行代码调用配置主窗口的方法：

   ```objective-c
   #import "AppDelegate.h"
   #import "AppDelegate+CYLTabBar.h" // 导入的分类文件
   
   @implementation AppDelegate
   
   
   - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       
       // 调用分类文件中的配置主窗口方法：
       [self hql_configureForTabBarController];
       
       return YES;
   }
   
   @end
   ```

6. 至此，常见的带 4 个 TabBarItem 的应用框架就搭建好啦：

   ![通用的 tabBar 样式](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/031149.jpg)



小结：将 `CYLTabBarController` 实例化为窗口的根视图控制器即可。



### 第三步：添加不规则加号按钮

创建一个继承自 `CYLPlusButton` 的子类对象 `CYLPlusButtonSubclass`。

#### `CYLPlusButtonSubclass.h` 声明遵守 `<CYLPlusButtonSubclassing>` 协议

```objective-c
#import "CYLPlusButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CYLPlusButtonSubclass : CYLPlusButton <CYLPlusButtonSubclassing>

@end

NS_ASSUME_NONNULL_END
```



#### `CYLPlusButtonSubclass.m` 中实现创建按钮的方法和遵守的协议方法

```objective-c
#import "CYLPlusButtonSubclass.h"

@implementation CYLPlusButtonSubclass

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

//上下结构的 button
- (void)layoutSubviews {
    [super layoutSubviews];

    // 控件大小,间距大小
    // 注意：一定要根据项目中的图片去调整下面的0.7和0.9，Demo之所以这么设置，因为demo中的 plusButton 的 icon 不是正方形。
    CGFloat const imageViewEdgeWidth   = self.bounds.size.width * 0.7;
    CGFloat const imageViewEdgeHeight  = imageViewEdgeWidth;

    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMargin  = (self.bounds.size.height - labelLineHeight - imageViewEdgeHeight) * 0.5;

    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdgeHeight * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdgeHeight  + verticalMargin * 2 + labelLineHeight * 0.5 - 1;

    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdgeWidth, imageViewEdgeHeight);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);

    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}

#pragma mark - IBActions

- (void)clickPublish {
    // 如果按钮的作用是触发点击事件，则调用此方法
}

#pragma mark - CYLPlusButtonSubclassing

+ (id)plusButton {
    CYLPlusButtonSubclass *button = [CYLPlusButtonSubclass buttonWithType:UIButtonTypeCustom];
    // 图片尺寸：56*56、67*66、49*48（凸出 15）
    UIImage *normalButtonImage = [UIImage imageNamed:@"post_normal"];
    UIImage *hlightButtonImage = [UIImage imageNamed:@"post_highlight"];
    [button setImage:normalButtonImage forState:UIControlStateNormal];
    [button setImage:hlightButtonImage forState:UIControlStateHighlighted];
    [button setImage:hlightButtonImage forState:UIControlStateSelected];
    
    // 设置背景图片
//    UIImage *normalButtonBackImage = [UIImage imageNamed:@"tabBar_post_back"];
//    [button setBackgroundImage:normalButtonBackImage forState:UIControlStateNormal];
//    [button setBackgroundImage:normalButtonBackImage forState:UIControlStateSelected];

    
    // 按钮图片距离上边距增加 5，即向下偏移，按钮图片距离下边距减少 5，即向下偏移。
    //button.imageEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
    
    
    //自定义宽度
    button.frame = CGRectMake(0.0, 0.0, 59, 59);
    // button.backgroundColor = [UIColor redColor];
    
    // if you use `+plusChildViewController` , do not addTarget to plusButton.
    // [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// 用来自定义加号按钮的位置，如果不实现默认居中。
+ (NSUInteger)indexOfPlusButtonInTabBar {
    return 2;
}

// 实现该方法后，能让 PlusButton 的点击效果与跟点击其他 TabBar 按钮效果一样，跳转到该方法指定的 UIViewController
+ (UIViewController *)plusChildViewController {

    UIViewController *v = [[UIViewController alloc] init];
    return v;
}

// 该方法是为了调整 PlusButton 中心点Y轴方向的位置，建议在按钮超出了 tabbar 的边界时实现该方法。
// 返回值是自定义按钮中心点 Y 轴方向的坐标除以 tabbar 的高度，小于 0.5 表示 PlusButton 偏上，大于 0.5 则表示偏下。
// PlusButtonCenterY = multiplierOfTabBarHeight * tabBarHeight + constantOfPlusButtonCenterYOffset;
+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    return  0.3;
}

// constantOfPlusButtonCenterYOffset 大于 0 会向下偏移，小于 0 会向上偏移。
+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    return (CYL_IS_IPHONE_X ? - 6 : 4);
}

@end
```



#### 在 `AppDelegate+CYLTabBar.m` 中注册该按钮

在初始化 `CYLTabBarController` 对象步骤之前注册按钮：

```objective-c
- (void)hql_configureForTabBarController {
    // 设置主窗口，并设置根视图控制器
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 💡💡💡 注册加号按钮
    [CYLPlusButtonSubclass registerPlusButton];
    
    // 初始化 CYLTabBarController 对象
    CYLTabBarController *tabBarController =
        [CYLTabBarController tabBarControllerWithViewControllers:[self viewControllers]
                                           tabBarItemsAttributes:[self tabBarItemsAttributes]];
    // 设置遵守委托协议
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
}
```



自此，加号按钮也添加完成啦。

![带不规则加号的 tabBar 样式](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/073824.jpg)





### 第四步：设置自定义 TabBar 样式

自定义 TabBar 字体、背景、阴影。

在 `AppDelegate+CYLTabBar.m` 文件中新增一个方法，用于设置 TabBar 样式：

```objective-c
/// 自定义 TabBar 字体、背景、阴影
- (void)customizeTabBarInterface {
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor cyl_systemGrayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor cyl_labelColor];
    
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateHighlighted];
    
    // 设置 TabBar 背景颜色：白色
    // 💡[UIImage imageWithColor] 表示根据指定颜色生成图片，该方法来自 <YYKit> 框架
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    // 去除 TabBar 自带的顶部阴影
    [[self cyl_tabBarController] hideTabBarShadowImageView];
    
    // 设置 TabBar 阴影，无效
    // [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tabBar_background_shadow"]];
    
    // 设置 TabBar 阴影
    CYLTabBarController *tabBarController = [self cyl_tabBarController];
    tabBarController.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    tabBarController.tabBar.layer.shadowRadius = 15.0;
    tabBarController.tabBar.layer.shadowOpacity = 0.2;
    tabBarController.tabBar.layer.shadowOffset = CGSizeMake(0, 3);
    tabBarController.tabBar.layer.masksToBounds = NO;
    tabBarController.tabBar.clipsToBounds = NO;
}
```

然后在该文件的配置方法中调用：

```objective-c
- (void)hql_configureForTabBarController {
    // 设置主窗口，并设置根视图控制器
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 注册加号按钮
    [CYLPlusButtonSubclass registerPlusButton];
    
    // 初始化 CYLTabBarController 对象
    CYLTabBarController *tabBarController =
        [CYLTabBarController tabBarControllerWithViewControllers:[self viewControllers]
                                           tabBarItemsAttributes:[self tabBarItemsAttributes]];
    // 设置遵守委托协议
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    
    // 💡💡💡 自定义 TabBar 字体、背景、阴影
     [self customizeTabBarInterface];
}
```

另外，不规则加号按钮的背景图片需要在 `CYLPlusButtonSubclass.m` 文件的 `+ (id)plusButton` 中设置：

```objective-c
// 设置背景图片
UIImage *normalButtonBackImage = [UIImage imageNamed:@"tabBar_post_back"];
[button setBackgroundImage:normalButtonBackImage forState:UIControlStateNormal];
[button setBackgroundImage:normalButtonBackImage forState:UIControlStateSelected];
```

下面是自定义后的 TabBar 样式示例：

![自定义 TabBar 样式](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/074517.jpg)



### 第五步：添加点击旋转动画

当点击 TabBarItem 时，为它设置旋转动画，需要让 AppDelegate 遵守 `<CYLTabBarControllerDelegate, UITabBarControllerDelegate>` 委托协议，以监听点击触发事件：

```
// 💡💡💡 声明遵守委托协议
@interface AppDelegate () <CYLTabBarControllerDelegate, UITabBarControllerDelegate>

@end

@implementation AppDelegate (CYLTabBar)

- (void)hql_configureForTabBarController {
		
		// 省略...
    
    // 初始化 CYLTabBarController 对象
    CYLTabBarController *tabBarController =
        [CYLTabBarController tabBarControllerWithViewControllers:[self viewControllers]
                                           tabBarItemsAttributes:[self tabBarItemsAttributes]];
    // 💡💡💡 设置让 AppDelegate 遵守委托协议
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
}
```

接下来是让 AppDelegate 实现委托协议方法，点击 TabBarItem 时触发旋转动画，点不规则加号按钮时触发放大动画：

```objective-c
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // 确保 PlusButton 的选中状态
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    NSLog(@"🔴\n 类名与方法名：%@，\n 第 %@ 行，\n description : %@，\n tabBarChildViewControllerIndex: %@， tabBarItemVisibleIndex : %@", @(__PRETTY_FUNCTION__), @(__LINE__), control, @(control.cyl_tabBarChildViewControllerIndex), @(control.cyl_tabBarItemVisibleIndex));
    
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control cyl_isPlusButton]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
        // 为加号按钮添加「缩放动画」
        [self addScaleAnimationOnView:animationView repeatCount:1];
    } else if ([control isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
        for (UIView *subView in control.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                animationView = subView;
                // 为其他按钮添加「旋转动画」
                [self addRotateAnimationOnView:animationView];
            }
        }
    }
}

/// 缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
     animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.5;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

/// 旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
   [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
       animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
   } completion:nil];
   
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
           animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
       } completion:nil];
   });
}
```

实现效果：

![带旋转动画的 TabBar](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/075457.gif)



### 第六步：添加 Lottie 动画

参考：<https://github.com/ChenYilong/CYLTabBarController/issues/341>

首先，为方便演示，我们从官方 Demo 中获取 Lottie 动画的 JSON 文件和相关资源文件。

![Lottie 资源文件](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/Jietu20191018-155746%402x.png)



然后，修改配置 tabBar 属性数组的方法 `- (NSArray *)tabBarItemsAttributes`，把 Lottie 文件的 URL 路径加上：

```objective-c
/*
 * tabBar 属性数组，带 Loggie 动画
 * 参考：<https://github.com/ChenYilong/CYLTabBarController/issues/341>
 *
 * 与上面的配置相比，需要再多设置两个属性：
 *   CYLTabBarLottieURL: 传入 lottie 动画 JSON 文件所在路径
 *   CYLTabBarLottieSize: LottieView 大小，选填
 *
 */
- (NSArray *)tabBarItemsAttributes {
    NSDictionary *homeTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"首页",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_home_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *myCityTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"同城",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_search_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *messageTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"消息",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_message_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };
    NSDictionary *accountTabBarItemsAttributes = @{
        CYLTabBarItemTitle: @"我的",
        CYLTabBarLottieURL : [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tab_me_animate" ofType:@"json"]],
        CYLTabBarLottieSize: [NSValue valueWithCGSize:CGSizeMake(33, 33)],
    };

    NSArray *tabBarItemsAttributes = @[
        homeTabBarItemsAttributes,
        myCityTabBarItemsAttributes,
        messageTabBarItemsAttributes,
        accountTabBarItemsAttributes
    ];
    return tabBarItemsAttributes;
}
```

![带 Lottie 动画的 TabBar 示例](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/080148.gif)



自此，我们通过 CYLTabBarController 框架实现了一个仿「闲鱼」TabBar 动画的应用。

