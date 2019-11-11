//
//  HQLHypnosisView.h
//  HQLHyponsister
//
//  Created by ToninTech on 16/8/15.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQLHypnosisView : UIView

@end

/*
 # 4. 深入理解 Core Graphics
 
 无论绘制 JPEG、PDF 还是视图的图层，都是由 Core Graphics 框架完成的。
 本章使用的 UIBezierPath，其实是将 Core Graphics代码封装在一系列方法中，以方便开发者调用，降低了绘图难度。
 为了真正了解绘图的过程与原理，必须深入学习 Core Graphics 是如何工作的。
 
 Core Graphics 是一套提供 2D 绘图功能的 C 语言 APl，使用 C 结构和 C 函数模拟了一套面向对象的编程机制，并没有 Objective-C 对象和方法。
 Core Graphics 中最重要的“对象”是图形上下文（ graphics context），图形上下文是 CGContextRef的“对象”，负责存储绘画状态（例如画笔颜色和线条粗细）和绘制内容所处的内存空间。

 视图的 drawRect: 方法在执行之前，系统首先为视图的图层创建一个图形上下文，然后为绘画状态设置一些默认参数。
 drawRect: 方法开始执行时，随着图形上下文不断执行绘图操作，图层上的内容也会随之改变。
 drawRect:执行完毕后，系统会将图层与其他图层一起组合成完整的图像并显示在屏幕上。

 有些功能只能使用 Core Graphics 完成，如：绘制渐变。
 
 带有 Ref 后缀的类型是 Core Graphics 中用来模拟面向对象机制的 C 结构。
 
 带有 Ref 后缀的类型的对象可能具有指向其他 Core Graphics “对象”的强引用指针，并成为这些“对象”的拥有者。
 但是 ARC 无法识别这类强引用和“对象”所有权，必须在使用完之后手动释放。
 
 规则是，如果使用名称中带有 create 或者 copy 的函数创建了一个 Core Graphics“对象”，就必须调用对应的 Release 函数并传入该对象指针。
 
 
 
 # 5.1 运行循环与重绘视图
 
 iOS 应用启动时会开始一个运行循环（run loop）。运行循环的工作是监听事件。当事件发生时，运行循环会为相应的事件找到合适的处理方法。
 
 只有当被调用的一系列处理方法执行完毕时，控制权才会再次回到运行循环。
 
 当应用将控制权交回给运行循环时，运行循环首先会检查是否有等待重新绘制的视图（即在当前循环收到过 setNeedsDisplay 消息的视图），
 然后向所有等待重绘的视图发送 drawRect: 消息，最后视图层次结构中所有视图的图层再次组合成一幅完整的图像并绘制到屏幕上。
 
 ## iOS 如何优化来保证用户界面的流畅性：
 1. 不重绘显示的内容没有改变的视图；
 2. 在每次事件处理周期（event handing cycle）中只发送一次 drawRect: 消息；
 
 iOS 会在运行循环的最后阶段集中处理所有需要重绘的视图，尤其是对于属性发生多次改变的视图，在每次事件处理周期中只重绘一次。

 */
