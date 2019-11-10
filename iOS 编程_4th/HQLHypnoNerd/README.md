> 《iOS编程（第四版）》Demo：HyponNerd
>
> 功能：在 HyponNerd 中，用户可以在两个视图层次结构之间自由切换。——第一个视图层次结构用于催眠自己，第二个用于设置催眠提醒时间。
>
> 要点：窗口、视图控制器、延迟加载机制、添加视图、访问视图、UITabBarController 标签页视图控制器、UITextField 委托与文本输入、运动效果、使用调试器、本地通知、



| Hypontize 截屏                                               | Reminder 截屏                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![Hypontize](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/171805.png) | ![Reminder](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/site_Images/171812.png) |



## main() 与 UIApplication
用 Objective-C 语言编写的程序的执行入口与 C 语言相同，都是 `main()` 函数:
```objective-c
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
```
### **UIApplicationMain** 函数:

* 1️⃣ 创建一个 **UIApplication** 对象（每个iOS应用都有且只有一个该对象），用于维护运行循环。
* 2️⃣ **UIApplicationMain** 函数还会创建某个指定类的对象，并将其设置为 **UIApplication** 对象的 delegate，该对象的类是由 **UIApplicationMain** 函数得最后一个实参指定的，该实参的类型是 **NSString** 对象，代表的某个类的类名。
* 以上代码块中，**UIApplicationMain** 会创建一个 **AppDelegate** 对象，并将其设置为 **UIApplication** 对象的 delegate。
* 在应用启动运行循环并开始接收事件前，**UIApplication** 对象会向其委托发送一个特定的消息（`didFinishLaunchingWithOptions:`）完成相应的初始化工作，该方法只会在应用启动完毕后调用一次。

初始化方法实现在 **AppDelegate.m** 文件中： 

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
```



## UIWindow

UIWindow 的常见用法示例：

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    // 1.创建 UIWindow 实例。
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // 2.指定 UIWindow 对象的根视图控制器。
    ViewController *viewController = [[ViewController alloc] init];
    self.window.rootViewController = viewController;

    // 3.设置背景色。
    self.window.backgroundColor = [UIColor whiteColor];

    // 4.设置 UIWindow 实例为主窗口并使其可见。
    [self.window makeKeyAndVisible];
  
    return YES;
}
```

* **UIWindow** 对象提供了一个方法 `setRootViewController` 将视图控制器的视图层次结构加入应用窗口。当程序将某个视图控制器设置为 **UIWindow** 对象的 `rootViewControl` 时，**UIWindow** 对象会将该视图控制器的 view 作为子视图加入窗口，同时负责维护 viewController 和 view 对应的生命周期。此外，还会自动调整 view 的大小，将其设置为与窗口的大小相同。
* `rootViewControl` 的view需要在应用启动完毕之后就显示，所以 **UIWindow** 对象会在设置完 `rootViewControl` 后立刻加载其 view。

### UIWindow 的主要作用

1. 作为 **UIView** 的最顶层容器；包含应用显示所需要的所有 **UIVIew**；
2. 传递触摸消息和键盘事件给 **UIView**；

### WindowLevel

```objective-c
UIKIT_EXTERN const UIWindowLevel UIWindowLevelNormal;	// 层级：0
UIKIT_EXTERN const UIWindowLevel UIWindowLevelAlert;	// 层级：1000
UIKIT_EXTERN const UIWindowLevel UIWindowLevelStatusBar __TVOS_PROHIBITED;	// 层级：2000
```



## 视图控制器

将视图控制器作为子视图添加到应用窗口（UIWindow）中。

视图控制器是 **UIViewController** 类或其子类对象。每个视图控制器都负责管理一个视图层次结构，包括视图层次结构中的视图并处理相关用户事件，以及将整个视图层次结构添加到应用窗口。

### UIViewController 的 `view` 属性

`view` 属性指向一个 `UIView` 对象。

`UIViewController` 对象可以管理一个视图层次结构，`view` 就是这个视图层次结构的根视图，当程序将 `view` 作为子视图加入窗口时，也会加入 `UIViewController` 对象所管理的整个视图层次结构。

### 根视图控制器

**UIWindow** 对象提供了一个方法将视图控制器的视图层次结构加入应用窗口：`setRootViewController`，当程序将某个视图控制器设置为 **UIWindow** 对象的 rootViewControl 时，**UIWindow** 对象会将该视图控制器的view作为子视图加入窗口，此外，还会自动调整view的大小，将其设置为与窗口的大小相同。`rootViewControl` 的 view 需要在应用启动完毕之后就显示，所以 **UIWindow** 对象会在设置完`rootViewControl` 后立刻加载其 view 。

**根视图控制器创建步骤：**

1. 创建 **UIViewController** 的子类
   ``@interface myViewController : UIViewController``
   
2. 在 **AppDelegate.h** 中声明属性
   ``@property (strong,nonatomic) UIViewController *viewController;``
   
3. 在 **AppDelegate.m** 中实现初始化

   ```objective-c
   // 方法一：
   // 设置根视图控制器
   BNRMyViewController *mvc = [[BNRyViewController alloc]init]; 
   self.window.rootViewController = mvc;
   
   // 方法二：
   // 获取指向 NSbundle 对象的指针，该 NSBundle 对象代表应用程序的主程序包
   // mainBundle 主程序包对应于文件系统中项目的根目录
   NSBundle *appBundle = [NSBundle mainBundle];
   // 告诉初始化方法在 appBundle 中查找 HQLReminderViewController.xib 文件
   self.viewController = [[myViewController alloc] initWithNibName:@"HQLReminderViewController" bundle: appBundle];
   //将 viewController 作为 window 的根视图控制器
   self.window.rootViewController =self.viewController;
   ```

上述方法二中对【对象是通过 XIB 文件创建的根视图控制器】设置同样可使用方法一实现，即：

```objective-c
HQLReminderViewController *rvc = [[HQLReminderViewController alloc] init];
self.window.rootViewController = rvc;
```

为什么向一个需要使用 NIB 文件的视图控制器发送 `init` 消息也能成功加载对应的视图？

* `initWithNibName：bundle：` 是 **UIViewController** 的指定初始化方法。
* 向视图控制器发送 `init` 消息会调用指定初始化方法  `initWithNibName：bundle：` 并为两个参数都传入`nil`。
* 即使向一个需要使用 NIB 文件的视图控制器发送 `init` 消息，**UIViewControl** 对象仍然会在应用程序中查找和当前 `UIViewControl` 子类同名的 XIB 文件。
* 💡 因此建议为 【**UIViewController** 子类】和【该子类需要载入的NIB文件】取相同的名称，这样当视图控制器需要加载视图时，会自动载入正确的 XIB 文件。    




### lazy loading 延迟加载视图

* 视图控制器不会在其被创建出来的那一刻马上创建并载入相应的视图，只有当应用需要将某个视图控制器的视图显示到屏幕上时，相应的视图控制器才会创建其视图（提高内存使用效率）。
* 也就是说，视图控制器刚被创建时，其 `view` 属性会被初始化为 **nil**。之后，当应用需要将视图控制器的视图显示到屏幕上时，如果 `view` 属性是 **nil**，就会自动调用 `loadview` 方法。
* 💡 为了实现视图延迟加载，`在initWithNibName：bundle：`中不应该访问 `view` 或 `View` 的任何子视图。凡是和 `view` 或 `view` 的子视图有关的代码，都应该在 `viewDidLoad` 方法中实现，避免加载不需要在屏幕上显示的视图。
* 视图控制器可以通过两种方式创建视图层次结构：
   *  代码方式：覆盖 **UIViewController** 中的 `loadView` 方法
   *  文件方式：使用 interface builder 创建一个 NIB 文件，然后加入所需的视图层次结构，最后视图控制器会在运行时加载由该 NIB 文件编译而成的 XIB 文件。

```objective-c
 - (void)loadView {  
		[super loadView];
   
    //创建一个 HQLHypnosisView 对象
    HQLHypnosisView *backgroundView = [[HQLHypnosisView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = backgroundView;
}
```

* 上述代码中，将 HQLHypnosisView 对象赋值给视图控制器的 `view` 属性。

* 子类视图控制器中的 `view` 属性继承自 `UIViewControl` 对象:

     `@property(null_resettable, nonatomic,strong) UIView *view;`
     如果视图还没有被设置，那么 getter 方法会首先调用自身的 `loadView` 方法，如果重写了 setter 或 getter 方法，子类必须调用父类。



## UIView

### 添加视图
`frame` 属性：用于确定与视图层次结构中其他视图的相对位置，从而将自己的图层与其他视图的图层正确组合屏幕上的图像。
`bounds` 属性:用于确定绘制区域，避免将自己绘制到图层边界之外。
`frame` 属性是从父视图的坐标系统来看的，而 `bounds` 属性是从本身的坐标系统来看的.

![frame与bounds的区别](http://upload-images.jianshu.io/upload_images/2648731-6b0e6cf74b47e40a.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

视图的相关结构：
Core Graphics( CG )
* **CGPoint**：2D空间中的位置坐标,（x,y）
    生成函数：```CGPointMake(x,y)```
* **CGSize**：某个对象的尺寸：width、height
   生成函数：```CGSizeMake(width,height)```
* **CGRect**：位置和尺寸：origin 和 size
   生成函数：```CGRectMake(x,y,width,height)```


```objective-c
//创建一个CGRect结构
//CGRect firstFrame = CGRectMake(160, 240, 100, 150);
CGRect firstFrame = self.window.bounds;

//创建HQLHypnosisView对象
HQLHypnosisView *firstView = [[HQLHypnosisView alloc] initWithFrame:firstFrame];

//设置HQLHypnosisView背景色
firstView.backgroundColor = [UIColor greenColor];

//将HQLHypnosisView对象加入UIWindow对象
[self.window addSubview:firstView];
```

也可以在 **HQLHypnosisView.m** 中覆写 `initWithFrame:` 方法设置 HQLHypnosisView 背景色。

```objective-c
- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        //设置HQLHyponsisView对象的背景颜色为透明
        self.backgroundColor = [UIColor clearColor];
      }
    return self;
}
```

### 视图层次的嵌套

```objective-c
HQLHypnosisView *secondView = [[HQLHypnosisView alloc] initWithFrame:secondFrame];
secondView.backgroundColor = [UIColor blueColor];

//将 secondView 添加到 window 上
[self.window addSubview:secondView];

//视图层次嵌套
//视图的frame所代表的位置是相对于其父视角的
//将 secondView 添加到 firstview 上
[firstView addSubview:secondView];
```

### 访问视图

通常情况下，在用户看到 XIB 文件中创建的视图之前需要对它们做一些额外的初始化工作。但是，关于视图的初始化代码不能写在视图控制器的初始化方法中—此时视图控制器并未加载 NIB 文件，所有指向视图的属性都是 `nil`。如果向这些属性发送消息，虽然编译时不会报错，但是运行时无法对这些属性做任何操作。

两种访问 NIB 文件中视图的方法：

* `-viewDidLoad:`  该方法会在视图控制器加载完视图之后被调用，此时视图控制器中所有视图属性都已经指向了正确的视图对象。
* `-viewWillAppear: ` 该方法会在视图控制器的 `view` 添加到应用窗口之前被调用。
  **区别：** **如果只需要在应用启动后设置一次视图对象，就选择 `viewDidLoad`；如果用户每次看到视图控制器的 view 时都需要对其进行设置，则选择 `viewWillAppear`。**
* 相反，`viewWillDisappear:  ` 和 `viewDidDisappear:` 方法会在每次视图控制器的 `view` 从屏幕上消失时被调用。

### 设置启动页面延时

```objective-c
//延时3秒
[NSThread sleepForTimeInterval:3.0];
```



#  运动效果

iOS 设备内嵌了许多功能强大的传感器，例如加速传感器，磁场传感器和三轴陀螺仪等。应用可以通过这些传感器了解设备的速度、方向和角度，并实现有用的功能。

例如，应用可以根据设备的方向自动将界面调整为横排模式或竖排模式。从iOS 7开始，Apple 引入了一些新 API，可以轻松为应用添加一种通过感应器实现的视差（parallax）效果。

在 **HQLHyponViewController.m** 中修改``drawHyponticMessage:``方法，为 **UILabel** 对象分别添加水平方向和垂直方向的视差效果，使 **UILabel** 对象的中心点坐标在每个方向上最多移动25点。


```objective-c
// 在屏幕随机位置绘制20个 UILabel 对象
- (void)drawHypnoticMessage:(NSString *)message {
    for (int i =0; i<20; i++) {
        UILabel *messageLabel = [[UILabel alloc] init];
        // 设置UILabel对象的文字和颜色
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        // 根据需要显示的文字调整 UILabel 对象的大小
        [messageLabel sizeToFit];

        // 获取随机x坐标
        // 使 UILabel 对象的宽度不超出 HQLHyponsisViewController 的 view 的宽度
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;

        // 获取随机y坐标
        // 使UILabel对象的高度不超出HQLHyponsisViewController的view的高度
        int height = (int)(self.view.bounds.size.width - messageLabel.bounds.size.height);
        int y =184 + arc4random() % height;

        // 设置 UILabel 对象的 frame
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;

        // 将UILabel对象添加到HQLHyponsisViewController的 view 中
        [self.view addSubview:messageLabel];

        // 运行效果：水平方向和垂直方向的视差效果
        // 设置 UILabel 对象的中心点坐标在每个方向上最多移动 25 点
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];

        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];  
}
```




# LocalNotification（本地通知）

**本地通知**（local notification）用于向用户提示一条消息，即使应用没有运行，用户也可以收到本地通知。
应用还可以通过后台服务器实现推送通知（push notification）.有关推送通知的技术细节请参考 Apple 的 Local and Push Notification Programming Guide（本地通知和推送通知编程指南）。
Demo:

![locolNotification.gif](http://upload-images.jianshu.io/upload_images/2648731-5bd235356d1e2922.gif?imageMogr2/auto-orient/strip)

实现本地通知方法代码如下：

```objective-c
- (IBAction)addReminder:(id)sender {
    
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@",date);
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    // 创建 UILocalNotification 对象
    UILocalNotification *note = [[UILocalNotification alloc] init];
    // 设置显示内容
    note.alertBody = @"Hypnotize me!";
    // 设置提醒时间
    note.fireDate = date;
    
    // 使用 scheduleLocalNotification: 方法注册通知
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    NSLog(@"addReminder run over");
}
```


