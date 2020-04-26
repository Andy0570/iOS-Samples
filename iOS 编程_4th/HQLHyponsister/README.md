要点：
* 视图与视图层次结构；
* 创建 `UIView` 子类；
* `frame` & `bounds`;
* Core Graphics 框架：
* 用 `UIBezierPath` 绘制同心圆、绘制图片并为图片添加阴影、绘制渐变色、
* 重绘与 `UIScrollView`；
* 类扩展（extension）;
* 拖动与分页；

视图层次结构：`UIWindow` - `UIScrollView` - `HQLHypnosisView`

![Hyponsister](https://upload-images.jianshu.io/upload_images/2648731-e83cbfaeeaaee39b.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)


## 4.1 视图基础

* 视图是 `UIView` 对象，或是 `UIView` 子类对象。
* 视图知道如何绘制自己。
* 视图可以处理事件，例如触摸（touch）。
* 视图会按层次结构排列，位于视图层次结构顶端的是应用窗口。

## 4.2 视图层次结构

任何一个应用都有且只有一个 `UIWindow` 对象。`UIWindow` 对象就像一个容器，负责包含应用中的所有视图。应用需要在启动时创建并设置 `UIWindow` 对象，然后为其添加其他视图，加入窗口的视图会成为该窗口的子视图（subview）。窗口的子视图还可以有自己的子视图，从而构成一个以 `UIWindow` 对象为根视图的视图层次结构。

  ```objectivec
// 想象一颗大树，UIWindow 就是树根，它有很多子视图（树枝），子视图上又可以添加很多子视图（树叶）
UIWindow - 子视图 - 子视图 - ...
         - 子视图 - 子视图 - ...
                 - 子视图 - ...
  ```

视图层次结构形成之后，系统会将其绘制到屏幕上，绘制过程可以分为两步：

1. 层次结构中的每个视图（包括 `UIWindow` 对象）分别绘制自己。视图会将自己绘制到图层（layer）上，每个 `UIView` 对象都有一个 `layer` 属性，指向一个 `CALayer` 类的对象。
2. 所有视图的图层组合成一幅图像，绘制到屏幕上。

## 4.3 创建 UIView 子类

### 视图及其 frame 属性

UIView 的指定初始化方法：

```objective-c
- (instancetype)initWithFrame:(CGRect)frame;
```

**视图的 `frame` 属性保存的是视图的大小和相对于父视图的位置。**

```objectivec
struct CGRect {
    CGPoint origin; // CGPoint 结构，（x, y），描述视图的起始点坐标位置（相对于父视图）。
    CGSize size;    // CGSize 结构，（width, height），描述视图的宽和高。
};
typedef struct CG_BOXABLE CGRect CGRect;
```

因为 `CGRect` 结构不是 Objective-C 对象，所以需要通过 `CGRectMake()` 函数创建一个 `CGRect` ：

```objectivec
// 参数：(origin.x, origin.y, size.width, size.height)
// 参数的值都是 CGFloat 类型，它的单位是点。
CGRect rect = CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
```

另外，参数中值的单位是点（point），不是像素（pixels）。点的大小与设备分辨率相关，取决于屏幕以多少像素显示一个点：在 Retina 显示屏上，一个点是两个像素高度、两个像素宽度；非 Retina 显示屏则是一个像素高度、一个像素宽度。

## 4.4 在 drawRect: 方法中自定义绘图

* 视图根据 `drawRect:` 方法将自己绘制到图层上。`UIView` 的子类可以覆盖 `drawRect:` 方法完成自定义的绘图任务
* 覆盖 `drawRect:` 方法后首先应该获取视图从 `UIView` 继承而来的 `bounds` 属性，该属性定义了一个矩形范围，表示视图的绘制区域。
* **`bounds` 属性表示的矩形位于自己的坐标系，`frame` 属性表示的矩形位于父视图的坐标系**，但是两个矩形的大小是相同的。

### frame 和 bounds 的不同用法

`frame` 和 `bounds` 表示的矩形用法不同。

* `frame` 用于确定与视图层次结构中其他视图的相对位置，从而将自己的图层与其他视图的图层正确组合成屏幕上的图像。
* `bounds` 属性用于确定绘制区域，避免将自己绘制到图层边界之外。

### 通过 UIBeizerPath 绘制圆形

`UIBezierPath` 用来绘制直线或曲线，从而组成各种形状。

以下是绘制同心圆的示例代码：

```objectivec
// 1.根据 bounds 计算中心点
CGPoint center;
center.x = bounds.origin.x + bounds.size.width / 2.0;
center.y = bounds.origin.y + bounds.size.height / 2.0;

// 定义最大半径
// 使最外层圆形成为视图的外接圆
// 使用视图的对角线作为最外层圆形的直径
// hypot() 函数，计算直角三角形的斜边长
float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;

// 1. 创建 UIBezierPath 对象
// UIBezierPath 用来绘制直线或曲线，从而组成各种形状。
UIBezierPath *path = [[UIBezierPath alloc] init];

// 从最外层的圆的直径递减画圆
for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {

    // 每次绘制新圆前，抬笔，重置起始点（x,y）
    // 否则会有一条将所有圆连接起来的横线。
    [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];

    // 2. 定义路径
    // 根据角度和半径【定义弧形路径】
    // 以中心点为圆心、radius 的值为半径，定义一个 0 到 2π 弧度的路径（整圆）
    [path addArcWithCenter:center
                    radius:currentRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
}

// 设置线条宽度为 10 点
path.lineWidth = 10;

// 通过 UIColor 类的实例方法设置线条颜色
// 使用 circleColor 作为线条颜色
[self.circleColor setStroke];

// 3. 绘制路径
[path stroke];
```

## 4.6 绘制图像

将图像绘制到视图上：

```objectivec
// 插入图片，绘制图像
- (void) drawRect:(CGRect)rect {
    UIImage *myImage = [UIImage imageNamed:@"iPhone6.png"];
    // 将图像绘制到视图上
    [myImage drawInRect:CGRectMake(0, 0, 414, 736)];
}
```

## 4.7 Core Graphics

无论绘制 JPEG、PDF 还是视图的图层，都是由 Core Graphics 框架完成的。本章使用的 `UIBezierPath`，其实是将 Core Graphics 代码封装在一系列方法中，以方便开发者调用，降低了绘图难度。为了真正了解绘图的过程与原理，必须深入学习 Core Graphics 是如何工作的。

 Core Graphics 是一套提供 2D 绘图功能的 C 语言 APl，使用 C 结构和 C 函数模拟了一套面向对象的编程机制，并没有 Objective-C 对象和方法。**Core Graphics 中最重要的“对象”是图形上下文（ graphics context），图形上下文是 CGContextRef的“对象”，负责存储绘画状态（例如画笔颜色和线条粗细）和绘制内容所处的内存空间。**

视图的 `drawRect:` 方法在执行之前，系统首先为视图的图层创建一个图形上下文，然后为绘画状态设置一些默认参数。 `drawRect:` 方法开始执行时，随着图形上下文不断执行绘图操作，图层上的内容也会随之改变。 `drawRect:` 执行完毕后，系统会将图层与其他图层一起组合成完整的图像并显示在屏幕上。

大部分视图的绘图功能都可以通过直接调用 Core Graphics 函数完成。但是，有些功能只能使用 Core Graphics 完成，如：绘制渐变。

带有 Ref 后缀的类型是 Core Graphics 中用来模拟面向对象机制的 C 结构。**带有 Ref 后缀的类型的对象可能具有指向其他 Core Graphics “对象”的强引用指针，并成为这些“对象”的拥有者。**但是 ARC 无法识别这类强引用和“对象”所有权，必须在使用完之后手动释放。规则是，**如果使用名称中带有 `create` 或者 `copy` 的函数创建了一个 Core Graphics“对象”，就必须调用对应的 `Release` 函数并传入该对象指针。**

## 4.8 阴影和渐变

为图片添加阴影效果，在 `drawRect:` 方法中添加如下代码 ：

```objectivec
// 保存绘图状态
CGContextSaveGState(UIGraphicsGetCurrentContext());

// 设置阴影偏移量、模糊指数
CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(4, 7), 2);

// 创建UIImage对象
UIImage *logoImage2 = [UIImage imageNamed:@"logo.png"];

// 将图像绘制到视图
CGRect logoBounds = CGRectMake(bounds.size.width/2.0-100, bounds.size.height/2.0-140, 200, 280);
[logoImage2 drawInRect:logoBounds];

// 恢复绘图状态
CGContextRestoreGState(UIGraphicsGetCurrentContext());
```

渐变用来在图形中填充一系列平滑过渡的颜色，在 `drawRect:` 方法中添加如下代码 ：

```objectivec
// 渐变：在图形中填充一系列平滑过渡的颜色
CGContextSaveGState(UIGraphicsGetCurrentContext());

CGFloat locations [2] ={0.0,1.0};
CGFloat components[8] ={1.0,0.5,0.0,1.0,    //起始颜色为红色
                        0.0,1.0,1.0,1.0};   //终止颜色为黄色

//色彩范围容器
CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();

//渐变属性：颜色空间、颜色、位置、有效数量
//CGGradientCreateWithColorComponents:创建包含渐变的CGGradientRef对象
CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);

CGPoint startPoint = CGPointMake(0,0);
CGPoint endPoint = CGPointMake(bounds.size.width,bounds.size.height);

//绘制线性渐变
CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), gradient, startPoint, endPoint, 0);

CGGradientRelease(gradient);
CGColorSpaceRelease(colorspace);

//恢复 Graphical Context 图形上下文
CGContextRestoreGState(UIGraphicsGetCurrentContext());
```

请注意，与填充颜色不同，无法使用渐变填充路径——渐变会直接填满整个图形上下文。因此，**如果需要将渐变应用在指定路径范围以内，必须使用剪切路径（ clippingpath）裁剪图形上下文。**同时，与绘制阴影时的情况类似，没有函数可以删除剪切路径，同样需要在使用剪切路径之前保存绘图状态，填充渐变之后再恢复绘图状态。



## 5. 视图：重绘与 UIScrollView

当用户触摸视图时，视图会收到 `touchesBegan:withEvent:` 消息处理触摸事件。

```objectivec
// 用户触摸视图 -——> 改变 circleColor 颜色 -——> 重绘整个视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches  anyObject];
    if (touch.tapCount ==1 ) {

    NSLog(@"%@ was touched",self);
        
    //获取三个0到1之间的数字
    float red   = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue  = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    self.circleColor = randomColor;
        
    }
}
```

## 5.1 运行循环和重绘视图

iOS 应用启动时会开始一个运行循环（run loop）。运行循环的工作是监听事件。当事件发生时，运行循环会为相应的事件找到合适的处理方法（类似于单片机中的中断处理机制）。只有当被调用的一系列处理方法执行完毕时，控制权才会再次回到运行循环。

当应用将控制权交回给运行循环时，运行循环首先会检查是否有等待重新绘制的视图（即在当前循环收到过 `setNeedsDisplay` 消息的视图），然后向所有等待重绘的视图发送 `drawRect:` 消息，最后视图层次结构中所有视图的图层再次组合成一幅完整的图像并绘制到屏幕上。

###  如何保证用户界面的流畅性

iOS 做了两方面来保证用户界面的流畅性：

1. 不重绘显示的内容没有改变的视图；
2. 在每次事件处理周期（event handing cycle）中只发送一次 `drawRect:` 消息。iOS 会在运行循环的最后阶段集中处理所有需要重绘的视图，尤其是对于属性发生多次改变的视图，在每次事件处理周期中只重绘一次。

为了标记视图需要重绘，必须向其发送 `setNeedsDisplay` 消息。

iOS SDK 中提供的视图对象（如 `UILabel`、`UIButton` ...）会自动在显示的内容发生改变时向自身发送 `setNeedsDisplay` 消息。

而对于自定义的 `UIView` 子类，必须手动向其发送 `setNeedsDisplay` 消息。

## 5.2 类扩展（extension）

将属性声明在头文件和类扩展中的区别？

头文件是一个类的“用户手册”，其他类可以通过头文件知道该类的功能和使用方法。**使用头文件的目的是向其他类公开该类声明的属性和方法，也就是说，头文件中声明的属性和方法对其他类是可见的 （visible）。**

但是，并不是每一个属性或方法都要向其他类公开。**只会在类的内部使用的属性和方法应当声明在类扩展中。** `circleColor` 属性只会被 `BNRHypnosisView` 使用，其他类不需要使用该属性，因此它应该被声明在类扩展中。

在类扩展中声明类的内部属性和方法是良好的编程习惯，这样做可以保持头文件的精简，避免内部实现细节的暴露，保证头文件中全部是其他类确实需要使用的属性和方法，从而让其他开发者更容易理解如何使用该类。

```objectivec
// 在【类扩展】（class extensions）中声明属性和方法，表明该属性和方法只会在类的内部使用
// 子类同样无法访问父类在类扩展中声明的属性和方法
@interface HQLHypnosisView ()

@property (nonatomic, strong) UIColor *circleColor;

@end
```

## 5.3 使用 UIScrollView

**UIScrollView** 类为展示内容比应用程序窗口大的视图提供支持。它允许用户通过触控手势卷起内容并且通过捏合手势放大缩小内容。
通常情况下，**UIScrollView** 对象适用于那些尺寸大于屏幕的视图。当某个视图是 **UIScrollView** 对象的子视图时，该对象会画出该视图的某块区域（形状为矩形）。当用户按住这块矩形区域并移动手指（即拖动，pan）时，**UIScrollView** 对象会改变该矩形所显示的子视图区域。

### 在UIScrollView中放一张2倍于窗口大小的视图 
Demo：
![ScrollViewDemo.gif](http://upload-images.jianshu.io/upload_images/2648731-17bba3785a51a275.gif?imageMogr2/auto-orient/strip)

视图层次：UIWindow ->UIViewControl -> UIScrollView -> HyponsisView视图。

实现方法：覆盖 UIViewController 中的 `viewDidLoad` 方法，创建视图层次结构。

```objectivec
- (void)viewDidLoad {
    
    //----------------------创建一个超大视图--------------------------
    // 根视图控制器 中放 UIScrollView ,UIScrollView 中放 HyponsisView
    
    // UIScrollView
    CGRect screenRect = self.view.frame;
    
    // HyponsisView
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    bigRect.size.height *= 2.0;
    
    //创建一个 UIScrollView 对象，将其尺寸设置为窗口大小
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    self.view = scrollView;
    
    //创建一个有着超大尺寸的 HQLHypnosisView 对象并将其加入 UIScrollView 对象
    HQLHypnosisView *hyponsisView = [[HQLHypnosisView alloc] initWithFrame:bigRect];
    
    [scrollView addSubview:hyponsisView];
    
    //告诉 UIScrollView 对象“取景”范围有多大
    scrollView.contentSize = bigRect.size;
}
```

### 拖动与分页显示

在 `UIScrollView` 中放左右两张视图，实现分页显示效果（类似于轮播器显示效果）。

`UIScrollView` 对象的分页实现原理是：`UIScrollView` 对象会根据其 `bounds` 的尺寸，将 `contentSize` 分割为尺寸相同的多个区域。拖动结束后，`UIScrollView` 实例会自动滚动并只显示其中的一个区域。

同样覆盖 `viewDidLoad` 方法创建视图层次结构：

```objectivec
- (void)viewDidLoad {    
    //创建两个 CGRect 结构分别作为 UIScrollView 对象和 HQLHypnosisView 对象的 frame
    
    CGRect screenRect = self.view.frame;
    
    //设置 UIScrollView 对象的 contentSize 的宽度是屏幕宽度的2倍，高度不变
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;

    //创建一个 UIScrollView 对象，将其尺寸设置为窗口大小
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    //设置UIScrollView 对象的“镜头”的边和其显示的某个视图的边对齐
    [scrollView setPagingEnabled:YES];
    
    self.view = scrollView;
    
    //创建第一个大小与屏幕相同的 HQLPictureView 对象并将其加入 UIScrollView 对象
    HQLPictureView *pictureView = [[HQLPictureView alloc] initWithFrame:screenRect];
    [scrollView addSubview:pictureView];
    
    //创建第二个大小与屏幕相同的 HQLHypnosisView 对象并放置在第一个 HQLPictureView 对象的右侧，使其刚好移除屏幕外
    screenRect.origin.x +=screenRect.size.width;
    
    HQLHypnosisView *anotherView = [[HQLHypnosisView alloc] initWithFrame:screenRect];
    
    [scrollView addSubview:anotherView];
    
    //告诉 UIScrollView 对象“取景”范围有多大
    scrollView.contentSize = bigRect.size;

}
```