**UIStackView** 堆栈视图是 iOS 9 引入的新特性，用于简化自动布局（Auto Layout），适用于水平或者垂直排布多个子视图的场景。

因为 **UIStackView** 适用于StoryBoard 或者 NIB 情况下布局 UI 控件，因此参考了两个 Demo 学习使用： 


* [【原文】iOS 9: Getting Started with UIStackView](https://code.tutsplus.com/tutorials/ios-9-getting-started-with-uistackview--cms-24193)
* [【译文】 iOS 9: UIStackView 入门](http://www.cocoachina.com/ios/20150623/12233.html)
* [【原文】An Introduction to Stack Views in iOS 9 and Xcode 7](https://www.appcoda.com/stack-views-intro/)
* [【译文】iOS9 Xcode7 下的布局神器 Stack Views](https://www.jianshu.com/p/e81c9fb0bcd3)



记录总结了几个重点内容：

1. `UIStackView` 的布局属性设置；
2. 添加和移除子视图；
3. 使用 Size Class 适配 Stack View；
4. 学习使用`Vertical Stack View` 和 `Horizontal Stack View`的相互嵌套。

另一个需要记住的是，Stack View 会被当成 Container View。所以它是一个不会被渲染的 `UIView` 子类。它不像其他 `UIView` 子类一样，会被渲染到屏幕上。这也意味着设置其 `backgroundColor` 属性或重载 `drawRect:` 方法都不会产生任何效果。

## 一、UIStackView 布局属性
![属性检查器设置](http://upload-images.jianshu.io/upload_images/2648731-47dc95ea5f00d861.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![堆栈视图的两种布局方式](https://upload-images.jianshu.io/upload_images/2648731-2e8d9f6a2e99a605.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



* **Axis**：设置 Stack View 子视图的布局排列方式，水平堆栈（沿 X 轴）布局还是垂直堆栈（沿 Y 轴）布局。

  ```objective-c
  typedef enum UILayoutConstraintAxis : NSInteger {
      UILayoutConstraintAxisHorizontal = 0, // 水平堆栈布局
      UILayoutConstraintAxisVertical = 1    // 垂直堆栈布局
  } UILayoutConstraintAxis;
  ```

* **Alignment**：设置垂直于布局方向（**Axis** 轴线）上的子视图的对齐方式。

  ```objective-c
  /** 
    UIStackViewAlignmentFill 会调整子视图的大小以填充 UIStackView 容器。
    而其他布局方式不会调整子视图大小，会使用子视图的固有内容大小（intrinsicContentSize）来布局子视图。
   */
  typedef enum UIStackViewAlignment : NSInteger {
      UIStackViewAlignmentFill,
      UIStackViewAlignmentLeading,
      UIStackViewAlignmentTop = UIStackViewAlignmentLeading,
      UIStackViewAlignmentFirstBaseline,
      UIStackViewAlignmentCenter,
      UIStackViewAlignmentTrailing,
      UIStackViewAlignmentBottom = UIStackViewAlignmentTrailing,
      UIStackViewAlignmentLastBaseline
  } UIStackViewAlignment;
  ```

* **Distribution**：表示沿着布局方向（**Axis** 轴线）上的分布方式。

  ```objective-c
  typedef enum UIStackViewDistribution : NSInteger {
      UIStackViewDistributionFill = 0, // 填充，会调整子视图的大小以填充剩余空间。放大或缩小子视图时会使用子视图的压缩（compression resistance priority）、放大（hugging priority）优先级。
      UIStackViewDistributionFillEqually, // 均匀填充， 会调整子视图大小。
      UIStackViewDistributionFillProportionally, // 按比例分布，会调整子视图大小。
      UIStackViewDistributionEqualSpacing, // 分散对齐，子视图之间有间隙。
      UIStackViewDistributionEqualCentering // 中心对齐，
  } UIStackViewDistribution;
  ```

* **Spacing**：表示子视图之间的最小距离。

* **baselineRelativeArrangement**：布尔值，表示是否按照子视图的基线来调整垂直间距。

* **layoutMarginsRelativeArrangement**：布尔值，表示子视图布局时，是相对于 **UIStackView** 的边界（`bounds`） 、还是相对于其边距（`margins`）。



## 二、添加和移除子视图

开始使用 Stack View 前，我们先看一下它的属性 `subViews` 和 `arrangedSubvies` 属性的不同。

如果你想添加一个 subview 给 Stack View 管理，你应该调用 `addArrangedSubview:` 或 `insertArrangedSubview:atIndex:` 方法。`arrangedSubviews` 数组是 `subviews` 属性的子集。

要移除 Stack View 管理的 subview，需要调用 `removeArrangedSubview:` 和 `removeFromSuperview`。移除 arrangedSubview 只是确保 Stack View 不再管理其约束，而非从视图层次结构中删除，理解这一点非常重要。

```objective-c
// ⚠️ 添加子视图时，如果子视图不在视图层次结构中，系统会自动将其作为 subviews 添加。
- (void)addArrangedSubview:(UIView *)view;

// ⚠️ 移除子视图时，Stack View 只会将其移出 arrangedSubviews 数组，移出 arrangedSubview 只是确保Stack View 不再管理其约束，而非从视图层次中删除。
- (void)removeArrangedSubview:(UIView *)view;

// 将子视图插入到 arrangedSubview 数组中
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;
```

### Demo1 部分示例代码

```objective-c
#pragma mark - IBActions

// 点击按钮，添加一颗星星
- (IBAction)addStar:(id)sender {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // MARK: 通过调用 addArrangedSubview: 方法为 Stack View 添加并管理子视图
    [self.horizontalStackView addArrangedSubview:imageView];
    [UIView animateWithDuration:0.25 animations:^{
        /**
         由于 Stack View 自动为我们管理 Auto Layout constraints，
         我们只能调用 layoutIfNeeded 来实现动画。
         */
        [self.horizontalStackView layoutIfNeeded];
    }];
    
}

// 点击按钮，移除一颗星星
- (IBAction)removeStar:(id)sender {
    UIView *view = self.horizontalStackView.arrangedSubviews.lastObject;
    if (view) {
        // !!!: 调用 removeArrangedSubview: 只是告诉 Stack View 不再需要管理 subview 的约束。而 subview 会一直保持在视图层级结构中直到调用 removeFromSuperview 把它移除。
        [self.horizontalStackView removeArrangedSubview:view];
        // !!!: 还需要调用 removeFromSuperview 是把 subview 从视图层级中移除
        [view removeFromSuperview];
        [UIView animateWithDuration:0.25 animations:^{
            [self.horizontalStackView layoutIfNeeded];
        }];
    }
}
```


![](http://upload-images.jianshu.io/upload_images/2648731-495260d9a8121237.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)


## 三、使用 Size Class 适配 Stack View

使用 Size Class 可以让 iPhone 的 Stack View 在横屏下自适应，默认情况下是这样的

![](http://upload-images.jianshu.io/upload_images/2648731-7697a14edc11f33e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)



默认情况下，iPhone 旋转到水平状态时，图片还是竖直排布的。也就是说，**无论 iPhone 是竖屏状态还是横屏状态，图片数组默认都是竖直排列的**。

![默认iPhone横屏](http://upload-images.jianshu.io/upload_images/2648731-45d809504a737e0e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

但是如果我们想要在 iPhone 是横屏状态时，图片是水平排列的呢，就像下面这样，就需修改 Size Class 特性。

![使用Size Class 后的iPhone横屏](http://upload-images.jianshu.io/upload_images/2648731-d1b5ecd2ffe78555.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

首先需要看懂下面的一张图片：

![Size Class](http://upload-images.jianshu.io/upload_images/2648731-d3bc50721913110b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

如 iPhone Portrait 状态时，Horizontal Size Class = Compact，Vertiacal Size Class = Regular 即表示 iPhone 竖屏状态时，水平方向压缩（Width Compact），垂直方向正常（Height Regular）。

 

iPhone:

* 竖屏（Portrait）显示时，size class 为：Width Compact, Height Regular（宽度压缩，高度正常）。竖屏状态时，我们需要让图片数组按照垂直方向排列，因此 **wC hC** 一栏设置为 **Vertical**；
* 横屏（Landscape）显示时，size class 为：Width Compact，Height Compact（宽度和高度都压缩）。横屏状态时，我们需要让图片数组按照水平方向排列，因此 **wC hR** 一栏设置为 **Horizontal**；



具体设置项如下所示：

![Size Class 设置](http://upload-images.jianshu.io/upload_images/2648731-6430cc15e5966ca1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)





## 总结

**UIStackView** 可以极大简化用户界面的开发。使用 **UIStackView** 可以减少开发者为简单场景设置枯燥约束的步骤，可以把繁杂的工作交给 UIKit 管理。

你可能有一个问题，你是否应该使用 StackView？Apple 官方工程师建议开发人员应优先采用 StackView 来设计用户界面，然后仅在需要时才采用原始的自动布局方式，因此，开始使用 StackView 来设计你的用户界面吧，我想你会喜欢上它的。













