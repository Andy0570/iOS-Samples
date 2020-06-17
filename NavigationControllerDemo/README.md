本文介绍 `UINavigationController`  导航视图控制器相关的常用方法。

## 1. 创建 `UINavigationController` 并设置为应用窗口的根视图控制器

初始化 `UINavigationController` 对象时，需要传入 `UIVIewController` 实例对象的参数作为它的根视图控制器。再将 `UINavigationController` 对象设置为 `UIWindow` 应用窗口对象的根视图控制器。

在 Xcode 11 之前新创建的项目，示例代码如下：
```objectivec
/*
 * 视图控制器层级结构：
 * UIWindow -> UINavigationController -> MainTableViewController
 *
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置和初始化应用窗口的根视图控制器
    // 初始化应用窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 创建主列表视图控制器对象
    MainTableViewController *mainTableViewController = [[MainTableViewController alloc] initWithStyle:UITableViewStylePlain];
    // 💡设置窗口根视图控制器：UINavigationController
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainTableViewController];
    // 设置窗口背景色
    self.window.backgroundColor = [UIColor whiteColor];
    // 使窗口可见
    [self.window makeKeyAndVisible];
    
    // 💡可选，全局设置窗口导航栏颜色、字体
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    return YES;
}
```

在 Xcode 11 之后创建的项目，因为 Apple 引入了 `UIScene` 特性，示例代码如下：

```objectivec
// AppDelegate.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available(iOS 13.0, *)) {
        
    } else {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        ViewController *con = [[ViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
    }
    return YES;
}


// SceneDelegate.m
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // 使用此方法可以有选择地配置 UIWindow 窗口并将其附加到提供的 UIWindowScene 场景中。
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // 如果使用 storyboard，window 属性将会自动初始化并附加到场景中
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    // 该委托并不意味着连接场景或会话是新的（请参见 `application：configurationForConnectingSceneSession`）
    

    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setWindowScene:windowScene];
        
        ViewController *con = [[ViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
        
        [self.window setBackgroundColor:[UIColor whiteColor]];
        [self.window setRootViewController:nav];
        [self.window makeKeyAndVisible];
    }
}
```

## 2. 隐藏导航栏、工具栏

隐藏当前视图控制器顶部的导航栏：
```objectivec
[self.navigationController setNavigationBarHidden:YES];
```

隐藏当前视图控制器底部的工具栏：
```objectivec
[self.navigationController setToolbarHidden:YES];
```

### 使用场景

每当进入详情页面时，隐藏页面顶部的导航栏和页面底部的工具栏，推出该详情页时（即返回到上一个页面），再显示回页面顶部的导航栏和工具栏。

```objectivec
#pragma mark - Lifecycle

// 每当进入此页面时，隐藏页面顶部的导航栏和页面底部的工具栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
}

// 每当退出此页面时，不再隐藏页面顶部的导航栏和页面底部的工具栏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}
```


## 3. 视图入栈和出栈

### 3.1 推入下一个视图控制器

```objectivec
- (void)pushToNextViewController {
    // 实例化下一个视图控制器
    ViewController *secondViewController = [[ViewController alloc] initWithNibName:NSStringFromClass([ViewController class]) bundle:nil];
    // 将该视图控制器推入到导航视图控制器中，相当于入栈操作
    [self.navigationController pushViewController:secondViewController animated:YES];
}
```

### 3.2 返回上一个视图控制器

```objectivec
- (void)popToLastViewController {
    // 当前视图控制器，将从导航视图控制器堆栈中移除，并返回至上一个视图控制器，相当于出栈操作
    [self.navigationController popViewControllerAnimated:YES];
}
```

### 3.3 根据索引返回到指定的视图控制器

```objectivec
- (void)gotoIndexViewController {
    // 根据导航视图控制器中的全局序号，查找堆栈中指定序号的视图控制器
    UIViewController *viewController = [[self.navigationController viewControllers] objectAtIndex:2];
    // 然后跳转至该视图控制器
    [self.navigationController popToViewController:viewController animated:YES];
}
```

### 3.4 返回到指定的视图控制器

通过 `for-in` 循环遍历 `UINavigationController` 的 `viewControllers` 数组，找到需要返回的视图控制器页面，然后将导航视图控制器推出到该页面上。

```objectivec
for (UIViewController *controller in self.navigationController.viewControllers) {
    BOOL isKindOfClass = [controller isKindOfClass:[FisrtViewController class]];
    if (isKindOfClass) {
        [self.navigationController popToViewController:controller animated:YES];
    }
}
```

### 3.5 返回到根视图控制器

导航视图控制器中的所有子视图控制器，都将全部出栈，从而跳转到根视图控制器。

```objectivec
- (void)popToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
```

## 4. 设置导航栏标题、字体和颜色

```objectivec
self.navigationItem.title = @"首页";
[self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],NSForegroundColorAttributeName:ThemeColor}];
```

## 5. 导航栏相关属性设置

```objectivec
- (void)setNavigationItemAttributes {
    // 设置当前视图的导航栏标题
    self.navigationItem.title = @"首页";
  	self.navigationController.navigationBar.hidden = NO;

    // 设置顶部导航区的提示文字，prompt 属性表示在导航栏按钮上方显示的说明文字
    // self.navigationItem.prompt = @"Loading";
  
    // 设置导航栏背景是否透明
    self.navigationController.navigationBar.translucent = NO;
  
    // 设置导航栏系统样式
    // The navigation bar style that specifies its appearance.
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
  
    // 设置导航按钮文本颜色，默认蓝色
    // !!!: 此属性设置的是全局导航栏里面的 item 项的颜色
    // self.navigationController.navigationBar.tintColor = [UIColor greenColor];
}
```

## 6. 全局设置导航栏属性

```objectivec
// 设置导航栏上的 item 的颜色
[[UINavigationBar appearance] setTintColor:ThemeColor];

// 设置导航栏的背景色
[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
```
在 `UINavigationBar` 中，与导航栏颜色设置相关的两个属性：
```objectivec
/**
  tintColor 属性作用于 navigation items 和 bar button items

  @说明：
  1. tintColor 属性的行为在 iOS 7.0 中发生了变化。它不会再影响导航栏的背景色。
  2. tintColor 属性的行为及其描述被添加到了 UIView 中。
  3. 想要设置导航栏的背景颜色，请使用 barTintColor 属性。
 */
@property(null_resettable, nonatomic,strong) UIColor *tintColor;

/**
  barTintColor 属性作用于 navigation bar background

  注：除非将半透明属性（translucent）设置为 NO，否则默认情况下此颜色为半透明。
 */
@property(nullable, nonatomic,strong) UIColor *barTintColor API_AVAILABLE(ios(7.0)) UI_APPEARANCE_SELECTOR;  // default is nil
```


## 7. 删除导航栏底部线条

```objectivec
[self.navigationController.navigationBar setShadowImage:[UIImage new]];
```

删除导航栏底部线条，还有一个替代方法位于 Chameleon 框架中，该方法会把所有页面的底部线条删除：

```objectivec
self.navigationController.hidesNavigationBarHairline = YES;
```

## 8. 为导航栏右上角添加一个按钮

导航栏 `UINavigationBar` 上的按钮是 `UIBarButtonItem` 的实例。

```objectivec
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // 添加导航栏右侧按钮
    [self addNavigationRightBarbutton];
}


#pragma mark - Private

- (void)addNavigationRightBarbutton {
    // 设置当前视图右上角的导航栏按钮标题，以及按钮点击事件
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"按钮"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(rightBarButtonItemDidClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - IBActions

// 导航栏按钮点击事件方法
- (void)rightBarButtonItemDidClicked:(id)sender {
  // ...
}
```

## 9. 自定义导航按钮：左侧按钮、右侧按钮、中间标题

```objectivec
#pragma mark - Private

- (void)customizeNavigationBar {
    // --------------------------------------------
    // 实例化一个工具条按钮对象，它将作为我们新的导航按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(leftButtonDidClicked:)];
    // 将导航栏左侧按钮，设置为新的工具条按钮对象
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // --------------------------------------------
    // 同样为导航栏右侧的导航按钮，设置新的样式
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                        target:self
                                                        action:@selector(rightButtonDidClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // --------------------------------------------
    // 创建一个视图对象，它将作为我们导航栏的标题区
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [titleView setBackgroundColor:[UIColor brownColor]];
    // 新建一个标签对象，它将显示标题区的标题文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.text = @"我是自定义标题";
    [titleView addSubview:label];
    // 将视图对象设置为导航栏的标题区
    self.navigationItem.titleView = titleView;
}


#pragma mark - IBActions

- (void)leftButtonDidClicked:(id)sender {
    NSLog(@"Left Bar Button Did Clicked!");
}

- (void)rightButtonDidClicked:(id)sender {
    NSLog(@"Right Bar Button Did Clicked!");
}
```

![](https://upload-images.jianshu.io/upload_images/2648731-5d08637541bc114f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 10. 调整左上角返回按钮的边框距离

```objectivec
/// 直接设置
@property(nullable, nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
```
大部分情况下，我们需要指定左边返回按钮距离左边框的距离，可以如下设定：

```objectivec
// 【方法一】把系统返回按钮替换成了 UIButton
UIButton *backBt = [UIButton buttonWithType:UIButtonTypeSystem];
backBt.frame = CGRectMake(0, 0, 20, 20);
[backBt setBackgroundImage:[UIImage imageNamed:@"back"]
                  forState:UIControlStateNormal];
[backBt addTarget:self
           action:@selector(backToRootViewController)
 forControlEvents:UIControlEventTouchUpInside];
self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBt];

// 【方法二】在系统的返回按钮左侧加了一个带宽度的 Item
UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]
                             initWithImage:[UIImage imageNamed:@"back"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backToRootViewController)];
UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil
                                           action:nil];
// 设置边框距离，可以根据需要调节
fixedItem.width = -16;
self.navigationItem.leftBarButtonItems = @[fixedItem, leftItem];
```

## 11. 隐藏/去掉导航栏返回按钮文字，只显示一个左箭头

  ```objectivec
// 方法一：全局设置
// 隐藏返回按钮文字，将返回按钮的标题垂直方向向上偏移 60 pt
// 设置/获取标题栏竖直位置偏移，UIBarMetricsDefault(竖屏)
[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

// 隐藏返回按钮文字，将返回按钮的标题水平方向向左偏移 100 pt
[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];


// 方法二：
// 注意此法需要在前一界面内设置，而且不是全局的，但是下一个界面标题会居中   
self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                         initWithTitle:@""
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:nil];
  ```
* 用方法一隐藏返回按钮的文字以后，当上一个视图控制器的标题很长，会导致顶层视图控制器标题不居中显示的问题，修复的方法如下（建议做成 `UIViewController` 范畴(category)类）:

```objectivec
// 如果有上个界面，将上个界面的 title 置为空，还是绕到方法二来了
- (void)resetBackButtonItem {
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@""
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
}
```

* 自定义导航栏返回按钮，将其设置为一个 `UIButton` 对象，然后为按钮设置背景图片。

```objectivec
// 自定义导航栏返回按钮
UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
negativeSpacer.width = 0;

UIButton *button = [[UIButton alloc] init];
// 图片尺寸 22*22
[button setImage:[UIImage imageNamed:@"navigation_back_normal"] forState:UIControlStateNormal];
[button setImage:[UIImage imageNamed:@"navigation_back_hl"] forState:UIControlStateHighlighted];
button.frame = CGRectMake(0, 0, 33, 33);
if (@available(ios 11.0,*)) {
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10,0, 0);
}

[button addTarget:self
           action:@selector(backButtonTapClick)
 forControlEvents:UIControlEventTouchUpInside];
UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];

viewController.navigationItem.leftBarButtonItems = @[backButton];
```



## 12. 把返回按钮的文字替换为自定义文字

```objectivec
UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                            style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:nil];
self.navigationItem.backBarButtonItem = leftItem;
```
以上代码可以嵌入自定义的 `UINavigationController` 基类中，即：
```objectivec
// ---------  HQLBaseNavigationViewController.h   ---------
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLBaseNavigationViewController : UINavigationController

@end

NS_ASSUME_NONNULL_END


// ---------  HQLBaseNavigationViewController.m   ---------
#import "HQLBaseNavigationViewController.h"

@interface HQLBaseNavigationViewController ()

@end

@implementation HQLBaseNavigationViewController

// 执行此方法时，统一设置下一个视图控制器的返回按钮
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 第一个 controller 左 button 不确定, 其他 controller 左 button 为特定样式
    if (self.viewControllers.count > 0) {
        // 自定义导航栏返回按钮文字，统一设置为“返回”，默认是上一个视图控制器的标题
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        viewController.navigationItem.backBarButtonItem = backBarButtonItem;
        // 推入下一个视图控制器时，隐藏 TabBar 标签栏
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
```

![](http://upload-images.jianshu.io/upload_images/2648731-a699636de9abf51a.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/200)


## 13. 在导航栏上添加多个按钮

```objectivec
// 设置导航栏返回按钮
UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithTitle:@"返回"
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:nil];
self.navigationItem.backBarButtonItem = backBarButtonItem;
// 设置导航栏其他按钮
UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(backToRootViewController)];
self.navigationItem.leftBarButtonItem = closeBarButtonItem;
// 设置左侧自定义按钮是否与返回按钮共同存在
self.navigationItem.leftItemsSupplementBackButton = YES;
```

![](http://upload-images.jianshu.io/upload_images/2648731-4f7d88fd6b22404e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 14. UINavigationControllerDelegate

```objectivec
// 一般用于传递参数，或者做一些其它处理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
```



## 15. 欢迎页面时隐藏状态栏

在项目的 `Info.plist` 文件中添加 `Status bar is initially hidden` 字段并设置为 `YES` ，可以隐藏 App 在 LunchScreen（欢迎界面）时的状态栏：

```
<key>Status bar is initially hidden<key>
<value>YES<value>
```


## 16. 修改系统状态栏样式

系统状态栏样式 `UIStatusBarStyle` 是一个枚举类型：

```objectivec
typedef NS_ENUM(NSInteger, UIStatusBarStyle) {
    // 默认样式，自动为系统状态栏设置白色或者黑色字体
    UIStatusBarStyleDefault                                  = 0,
    // 白色状态栏文本，适用于暗色背景 
    UIStatusBarStyleLightContent     API_AVAILABLE(ios(7.0)) = 1,
    // 黑色状态栏文本，适用于亮色背景
    UIStatusBarStyleDarkContent     API_AVAILABLE(ios(13.0)) = 3, 

    // 以下两个枚举类型在 iOS 7.0 之后已失效，可以不用管
    UIStatusBarStyleBlackTranslucent NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 1,
    UIStatusBarStyleBlackOpaque      NS_ENUM_DEPRECATED_IOS(2_0, 7_0, "Use UIStatusBarStyleLightContent") = 2,
} API_UNAVAILABLE(tvos);
```

### 1. 全局状态栏样式设置：

在 AppDelegate 文件中 添加如下设置：

```objectivec
[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
```


### 2. `preferredStatusBarStyle` 方法

为当前视图控制器添加  `preferredStatusBarStyle` 方法，并返回所需要的状态栏枚举类型：

```objectivec
// 设置当前视图控制器系统状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
```

需要注意的是：

1. 如果该视图控制器没有被 `UINavigationController` 所拥有，那么你可以直接在这个方法中设置当前视图控制器的系统状态栏样式。

2. 如果该视图控制器是导航视图控制器的 `viewControllers` 之一，则此设置无效！

> `UINavigationController` 不会将 `preferredStatusBarStyle` 方法调用传递给它的子视图，而是由它自己管理状态，而且它也应该那样做。因为 `UINavigationController` 包含了它自己的状态栏；
>
>  因此，即使被 `UINavigationController` 所管理的视图控制器实现了 `preferredStatusBarStyle` 方法，也不会调用。


解决方法，自定义一个 `UINavigationController` 的子类对象，在这个子类中重写 `preferredStatusBarStyle` 方法，让其返回视图控制器中的状态栏设置。这样在 `UIViewController` 中添加的  `preferredStatusBarStyle` 方法即可奏效，如下：

```objectivec
@implementation MyNavigationController
  
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topViewController = self.topViewController;
    return [topViewController preferredStatusBarStyle];
}

@end
```



### 3. 设置导航视图控制器的 `barStyle` 属性

```objectivec
// UIBarStyleBlack 为黑色导航栏，此时系统状态栏字体为白色！
self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
// 默认样式，状态栏字体为黑色
self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
```

#### 示例

在项目的 **Targets** — **General** — **Deployment Info** — **Status Bar Style** 全局状态栏样式设置为 **Default**：

![](https://upload-images.jianshu.io/upload_images/2648731-99e8a03db1bd6668.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


在项目的 `Info.plist` 文件中添加如下字段，将 `View controller-based status bar appearance` 字段的值设置为 `YES`：

```
<key>View controller-based status bar appearance<key>
<value>YES<value>
```

在指定视图控制器页面设置系统状态栏样式：

```objectivec
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    // 进入当前页面时，设置指定的状态栏样式
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 退出当前页面时，恢复原设置
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}
```

### 17. 在导航栏添加搜索框

#### 方式一：添加 `UISearchBar`

```objectivec
// 「搜索」按钮
UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 32)];
containerView.backgroundColor = [UIColor clearColor];
containerView.layer.cornerRadius = 16;
containerView.layer.masksToBounds = YES;

UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:containerView.bounds];
// 设置搜索框中光标的颜色
searchBar.tintColor = [UIColor lightGrayColor];
// 搜索框背景色
searchBar.backgroundColor = [UIColor whiteColor];
searchBar.placeholder = @"搜索";
searchBar.delegate = self;
 [containerView addSubview:searchBar];
 containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
self.navigationItem.titleView = containerView;

// 适配 iOS 11，通过添加高度约束 44 来固定 iOS 11 中 UISearchBar 的高度
if (@available(iOS 11.0, *)) {
    [searchBar.heightAnchor constraintEqualToConstant:44].active = YES;
}
```

#### 方式二：添加自定义的  `UIButton`

```objectivec
// 自定义搜索按钮
UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
searchButton.frame = CGRectMake(0, 0, 190, 32);
searchButton.layer.cornerRadius = 16;
searchButton.layer.masksToBounds = YES;
searchButton.backgroundColor = [UIColor whiteColor];
// 标题
[searchButton setTitle:@"搜索" forState:UIControlStateNormal];
searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
[searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
// 🔍 图片，18*18
[searchButton setImage:[UIImage imageNamed:@"nav_sousuo"] forState:UIControlStateNormal];
searchButton.adjustsImageWhenHighlighted = NO;
// 设置图片、标题左对齐
searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
// 图片向右移动 10pt
searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10.0f, 0, 0);
// 标题向右移动 20pt
searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15.0f, 0, 0);
[searchButton addTarget:self action:@selector(navigationSearchButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
self.navigationItem.titleView = searchButton;
```



### 参考

* <https://www.jianshu.com/p/ae47fdbf28fd>
* <https://www.jianshu.com/p/9f7f3fa624e7>
* <https://www.jianshu.com/p/534054a8c897>
* <https://blog.csdn.net/lg767201403/article/details/93497250>
* [https://zhang759740844.github.io/2017/05/04/UINavigationController%E4%BD%BF%E7%94%A8/](https://zhang759740844.github.io/2017/05/04/UINavigationController使用/)

