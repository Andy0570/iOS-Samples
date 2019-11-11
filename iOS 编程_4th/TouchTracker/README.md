> TouchTracker 是一个画板应用，学习触摸事件和手势处理。
>
> 参考：[《iOS编程（第四版）[美]Christian Keur》](https://www.amazon.cn/gp/product/B013UG2ULW/ref=oh_aui_d_detailpage_o03_?ie=UTF8&psc=1) 

## 1. 触摸事件与UIResponder 
因为 **UIView** 是 **UIResponder** 的子类，所以覆盖以下四个方法就可以处理四种不同的触摸事件： 

```objective-c
// ① 一根手指或多根手指触摸屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;

// ② 一根手指或多根手指在屏幕上移动（随着手指的移动，相关的对象会持续发送该消息）
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;

// ③ 一根手指或多根手指离开屏幕
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;

// ④ 在触摸操作正常结束前，某个系统事件（例如突然来电话）打断了触摸过程
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
```

当系统检测到手指触摸屏幕的事件后，就会创建 **UITouch** 对象（一根手指的触摸事件对应一个**UITouch**对象）。发生触摸事件的 **UIView** 对象会收到不同阶段的以上四种消息。

**UITouch** 对象和事件响应的方法的工作机制：

* 一个 **UITouch** 对象对应屏幕上的一根手指。只要手指没有离开屏幕，相应的 **UITouch** 对象就会一直存在。这些 **UITouch** 对象都会保存对应的手指在屏幕上的当前位置。
* 在触摸事件的持续过程中，无论发生什么，最初发生触摸事件的那个视图都会在各个阶段收到相应的触摸消息。也就是说，<u>当某个视图发生触摸事件后，该视图将永远“拥有”当时创建的所有 **UITouch** 对象</u>。
* 读者自己编写的代码不需要也不应该保留任何 **UITouch** 对象。当某个 **UITouch** 对象的状态发生变化时，系统会向指定的对象发送特定的事件消息，并传入发生变化的 **UITouch** 对象。
* 触摸事件由系统添加至一个由 **UIApplication** 单例管理的事件队列。
* 当多根手指在<u>同一个视图、同一个时刻</u>执行相同的触摸动作时，**UIApplication** 会用<u>单个消息、一次分发所有相关的 **UITouch** 对象</u>。但是，因为 **UIApplication**对“同一时刻”的判断很严格，通常 **UIApplication** 都是发送<u>多个 **UIResponder** 消息，分批发送 **UITouch** 对象</u>。



## 2. 创建touchTracker画板应用

通过创建一个“画板”应用来简单描述触摸事件和手势处理,用户可以在该视图上触摸并绘制线条，借助多点触控，用户还可以同时画多根线条。
demo演示：

![](http://upload-images.jianshu.io/upload_images/2648731-63d1003dc8ec80dd.gif?imageMogr2/auto-orient/strip)
### 项目的组织结构
![TouchTracker](http://upload-images.jianshu.io/upload_images/2648731-da6ebd92baf2b34c.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



### 模型对象：定义一条线

通过两个点可以定义一条直线，所以 **HQLLine** 对象需要用 **begin** 属性和 **end** 属性来保存起点和终点。

```objective-c
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 描述线条的模型对象：起点 begin（x,y）、终点 end（x,y）
 */
@interface HQLLine : NSObject

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
```


## 3. 实现绘图功能

HQLDrawView 对象要实现绘图功能： 

*  管理正在绘制的线条、被选中的线条和绘制完成的线条。所以在类扩展中添加这几个属性：

```objective-c
@interface HQLDrawView () <UIGestureRecognizerDelegate>

// 保存当前线（多点触控，同时保存多线）
// key 是 UITouch 对象的内存地址，value 是 HQLLine 对象
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;

// 保存所有线
@property (nonatomic, strong) NSMutableArray *finishedLines;

// 单击手势选中的线条
// weak: ① finishedLines 数组会保存 selectedLine，是强引用；
//       ② 如果用户双击清除所有线条，finishedLines 数组会移除 selectedLine，这时 HQLDrawView会自动将 selectedLine 设置为 nil
@property (nonatomic, weak) HQLLine *selectedLine;

@end
```
> 当前线 **linesInProgress** 通过字典来保存
> 字典的key是一个NSValue对象，保存UITouch对象的内存地址。
> 字典的value就是UITouch对象所对应的线（HQLLine对象）。
>
> * **使用内存地址分辨UITouch对象** 的原因是：在触摸事件开始、移动、结束的整个过程中，其内存地址是不会改变的，内存地址相同的UITouch对象一定是同一个对象。
> * 而又用**NSValue**来封装**UITouch**对象的内存地址，而不是直接保存 **UITouch对象**是因为：**NSDictionary**及其子类**NSMutableDictionary**的键必须遵守**NSCopying协议**——键必须可以复制（可以响应copy消息）。**UITouch**并不遵守**NSCopying协议**，因为每一个触摸事件都是唯一的，不应该被复制。相反，**NSValue**遵守**NSCopying协议**，同一个**UITouch对象**会在触摸过程中创建包含相同内存地址的**NSValue对象**。



* 处理触摸事件：

```objective-c
#pragma mark 一根手指或多根手指触摸屏幕
// 触摸事件开始时,HQLDrawView 对象需要创建一个 HQLLine 对象，并将其begin属性和end属性设置为触摸发生时的手指位置
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        // 根据触摸位置创建 HQLLine 对象
        CGPoint location = [t locationInView:self];
        HQLLine *line = [[HQLLine alloc] init];
        line.begin = location;
        line.end   = location;
        // valueWithNonretainedObject：将 UITouch 对象的内存地址封装为 NSValue 对象
        // 使用内存地址分辨 UITouch 对象的原因是，在触摸事件开始、移动、结束的整个过程中，其内存地址不会改变，内存地址相同的 UITouch 对象一定是同一个对象。
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        // 保存当前线到字典中，key值是内存地址，value值是 HQLLine 对象
        self.linesInProgress[key] = line;
    }
    [self setNeedsDisplay];
}


#pragma mark 一根手指或多根手指在屏幕上移动
// 触摸事件继续时（手指在频幕上移动），HQLDrawView对象需要将end设置为手指的当前位置
- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        // 根据当前 UITouch 对象的内存地址找到key值，再找到value值，更新 HQLLine 对象的终点
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        HQLLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
    [self setNeedsDisplay];
}


#pragma mark 一根手指或多根手指离开屏幕
// 触摸结束时，将当前线linesInProgress保存到finishedLines数组中。
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        HQLLine *line = self.linesInProgress[key];
        // 将所有绘制完成的线，即 HQLLine 对象添加到_finishedLines数组中
        [self.finishedLines addObject:line];
        // 从当前线中移除 HQLLine 对象
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}


#pragma mark 在触摸操作正常结束前，某个系统事件打断了触摸进程
// 触摸取消事件：当系统中断了应用，触摸事件就会被取消，这是应用应该恢复到触摸事件发生前的状态，这里就简单的清楚所有正在绘制的线条。
- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        // 从当前线中移除 HQLLine 对象
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}
```



## 8. 响应对象链

**UIResponder** 对象可以接受触摸事件，而 **UIView**、**UIViewController**、**UIApplication** 和 **UIWindow** 等都是 **UIResponder** 的子类。因此，他们都可以可以接受触摸事件。

例如，虽然 **UIViewController** 不是视图对象，系统不能向 **UIViewController** 对象直接发送触摸事件，但是该对象能通过响应对象链接受事件。

**UIResponder** 对象拥有一个名为nextResponder的指针，相关的 **UIResponder** 对象可以通过该指针组成一个响应对象链。

* 当 **UIView** 对象属于某个 **UIViewController** 对象时，其nextResponder指针就会指向包含该视图的**UIViewController **对象。
* 当 **UIView** 对象不属于任何 **UIViewController** 对象时，其nextResponder指针就会指向该视图的父视图。**UIViewController** 对象的nextResponder通常会指向其视图的父视图。最顶层的父视图是 **UIWindow** 对象，而 **UIWindow** 对象的nextResponder指向的是 **UIApplication** 单例。
* 如果没有为某个 **UIResponder** 对象覆盖特定的事件处理方法，那么该对象的nextResponder会尝试处理相应的触摸事件。最终，该事件会传递给**UIApplication**（响应对象链的最后一个对象），如果 **UIApplication** 也无法对其处理，系统就会丢弃该事件。

除了由 **UIResponder** 对象向nextResponder转发消息，也可以直接向nextResponder发送消息。
```[[self nextResponder]touchesBegan:touches withEvent:event];  ```



### UIController

* **UIController**是部分Cocoa Touch类的父类，例如**UIButton**和**UISlider**。
* **UIControl** 对象并不是直接向目标对象发送消息，而是通过 **UIApplication** 转发。**UIApplication** 在转发源自 **UIControl** 对象的消息时，会先判断目标对象是不是 `nil`。如果是 `nil`，**UIApplication** 就会先找出 **UIWindow** 对象的第一响应对象，然后向第一响应对象发送相应的动作消息。



## 13. UIGestureRecognizer 与 UIMenuController

* **UIGestureRecognizer **对象可以用于识别特定手势，例如“张开或者合拢手指”（pinch）或者滑动（swipe）手势。
* 在为应用添加手势识别功能时，需要<u>针对特定的手势创建 **UIGestureRecognizer** 子类对象，而不是直接使用 **UIGestureRecognizer** 对象。</u>

### 双击手势
添加双击手势需要在**HQLDrawView.m**的初始化方法中创建一个**UITapGestureRecognize**对象，并注册触发的手势方法。



```objective-c
// -----------------------------------------------
// 使用 UIGestureRecognize 子类步骤：
// ① 创建对象并设置目标-动作对；
// ② 将该对象“附着”在某个视图上；

// UIGestureRecognize 子类 - UITapGestureRecognizer
// 1️⃣ 双击手势
UITapGestureRecognizer *doubleTapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(doubleTap:)];
// 设置点击次数为2
doubleTapRecognizer.numberOfTapsRequired = 2;
// 设置手势优先：延迟 UIView 收到 UIResponder 消息
// 只有双击手势识别失败后，才能再去识别 UIResponder 消息的触摸手势，防止误识别。
doubleTapRecognizer.delaysTouchesBegan = YES;
// 将该对象“附着”在视图上；
[self addGestureRecognizer:doubleTapRecognizer];
```




```objective-c
// doubleTap:双击手势方法：删除所有线条
- (void) doubleTap:(UIGestureRecognizer *)gr {
NSLog(@"Recognized Double Tap");
[self.linesInProgress removeAllObjects];
[self.finishedLines removeAllObjects];
[self setNeedsDisplay];
}
```

### 单击手势
在**HQLDrawView.m**的初始化方法中创建一个**UITapGestureRecognizer**单击手势对象。
```objective-c
// 2️⃣ 单击手势
UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tap:)];
// 同样设置手势优先：① 延迟 UIView 收到 UIResponder 消息
tapRecognizer.delaysTouchesBegan = YES;
// ② 需要双击手势识别失败时再识别单击手势
[tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
[self addGestureRecognizer:tapRecognizer];
```




```objective-c
#pragma mark - 单击手势

- (void) tap:(UIGestureRecognizer *)gr {
    
    NSLog(@"Recognized tap");
    // 获取点击的坐标位置
    CGPoint point = [gr locationInView:self];
    // 根据该点找到最近的线
    self.selectedLine = [self lineAtPoint:point];
    
    // 弹出删除菜单
    if (self.selectedLine) {
        // 使视图成为 UIMenuItem 动作消息的目标
        [self becomeFirstResponder];
        // 获取 UIMenuController 对象
        UIMenuController *menu = [UIMenuController sharedMenuController];
        // 创建一个新的标题为 “Delete” 的 UIMenuItem 对象
        UIMenuItem *deleteItem =
            [[UIMenuItem alloc] initWithTitle:@"删除"
                                       action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        // 先为 UIMenuController 对象设置显示区域，然后将其设置为可见
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }else {
        // 如果没有选中的线条，就隐藏 UIMenuController 对象
        // 即点击其他空白区域，隐藏 UIMenuController 对象
        [[UIMenuController sharedMenuController] setMenuVisible:NO
                                                       animated:YES];
    }
    // 用绿色重绘这根线条
    [self setNeedsDisplay];
}

#pragma 根据点找出最近的线
- (HQLLine *) lineAtPoint:(CGPoint) p {
    
    // 找出离P最近的 HQLLine 对象
    for (HQLLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        //检查线条的若干点
        for (float t= 0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            // 如果线条的某个点和p的距离在20点以内，就返回相应的HQLLine对象
            if (hypot(x-p.x, y-p.y) < 20.0) {
                return l;
            }
        }
    }
    return nil;
}

#pragma UIMenuItem 动作方法：删除线

- (void) deleteLine:(id) sender {
    // 从已经完成的线条中删除选中的线条
    [self.finishedLines removeObject:self.selectedLine];
    // 重画整个视图
    [self setNeedsDisplay];
}
```



### UIMenuController

以上单击手势方法 ```tap:``` 中用到了 **UIMenuController** 对象

*	**UIMenuController **对象用于在用户手指按下的地方显示一组 **UIMenuItem** 对象（菜单项），每个 **UIMenuItem** 对象都有自己的标题和动作方法。
 *显示 **UIMenuItem** 对象的 ∫ 对象必须是当前 **UIWindow** 对象的第一响应对象。

> 如果要将某个自定义的 **UIView** 子类对象设置为第一响应者 ```[self becomeFirstResponder]``` ，就必须在HQLDrawView.m中覆盖 ```canBecomeFirstResponder``` 方法并返回YES。

```objective-c
- (BOOL) canBecomeFirstResponder {
return YES;
}
```

> 还需要为**UIMenuController**对象实现删除线的动作方法，才会在选中某条线时显示**UIMenuController**对象。如果**UIMenuController**对象的动作方法没有实现，应用就不会显示**UIMenucontroller**对象。


```objective-c
- (void) deleteLine:(id) sender {
//从已经完成的线条中删除选中的线条
[self.finishedLines removeObject:self.selectedLine];
//重画整个视图
[self setNeedsDisplay];
}
```


### 5. UILongPressGestureRecognizer
### 长按手势

* **UILongPressGestureRecognizer** 对象默认会将持续时间超过0.5秒的触摸事件识别为长按手势。设置 **UILongPressGestureRecognizer** 对象的 ```minimumPressDuration``` 属性可以修改这个时间。   
* **UILongPressGestureRecognizer **对象在识别出长按手势后，会持续跟踪该手势并在不同的阶段分别触发三种不同的事件：   
   1. **UIGestureRecognizerStatePossible**（可能会发生）
   2. **UIGestureRecognizerStateBegan**（长按开始）
   3. **UIGestureRecognizerStateEnded**（长按结束）



在**HQLDrawView.m**的初始化方法中创建一个**UILongPressGestureRecognizer**长按手势对象。
```objective-c
// -----------------------------------------------
        // UIGestureRecognize 子类 - UILongPressGestureRecognizer
        // 3️⃣ 长按手势
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(longPress:)];
        // UILongPressGestureRecognizer 对象默认会将持续时间超过 0.5秒的触摸事件识别为长按手势
        // 设置 minimumPressDuration 属性可修改该时间
        pressRecognizer.minimumPressDuration = 0.6;
        [self addGestureRecognizer:pressRecognizer];
```

> 在**HQLDrawView.m**中实现longPress:方法

```objective-c
- (void) longPress:(UIGestureRecognizer *)gr {
    
    // 长按开始
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        // 选中被长按的线
        self.selectedLine = [self lineAtPoint:point];
        if (self.selectedLine) {
            // 删除当前线
            [self.linesInProgress removeAllObjects];
        }
    }
    // 长按结束
    else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}
```


## UIPanGestureRecognizer（拖动手势）以及同时识别多个手势

在**HQLDrawView.m**中的类扩展中将**HQLDrawView**声明为遵守**UIGestureRecognizerDelegate**协议。然后声明一个类型为**UIPanGestureRecognizer**的属性:
```@property (nonatomic,strong) UIPanGestureRecognizer *moveRecognizer;```

> 更新**HQLDrawView.m**的```initWithFrame:```方法,创建一个**UIPanGestureRecognizer**对象。默认情况下，UIGestureRecognize对象在识别出特定的手势时，会“吃掉”所有和该手势有段的UItouch对象，这边选择否“NO”，让UILongPressGestureRecognizer对象和UIPanGestureRecognizer对象能够同时识别手势。

```objective-c
// 4️⃣ 移动手势
self.moveRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(moveLine:)];
self.moveRecognizer.delegate = self;
// cancelsTouchesInView 属性默认为 YES，这个对象会在识别出特定手势时，“吃掉”所有和该手势有关的 UITouch 对象；
// 这里设置为NO，因为还要处理相关的 UITouch 对象：
// 一开始，画板上没有任何线时，在屏幕上划动就会识别出 moveRecognizer 手势，它会发送 moveLine:消息。执行该消息，如果没有选中的线条就直接返回。与此同时 YES 的cancelsTouchesInView 属性拦截了所有的 UIResponder 方法，就无法处理 UITouch 对象，就无法画线。
self.moveRecognizer.cancelsTouchesInView = NO;
[self addGestureRecognizer:self.moveRecognizer];
```

> 使用UIGestureRecognizerDelegate协议中的一个协议```gestureRecognizer: shouldRecognizeSimultaneouslyWithGestureRecognizer:```，当某个**UIGestureRecognizer**子类对象识别出特定的手势后，如果发现其他的**UIGestureRecognizer**子类对象也识别出了特定的手势，就会向其委托对象发送```gestureRecognizer: shouldRecognizeSimultaneouslyWithGestureRecognizer:```消息。如果相应的方法返回YES，那么当前的**UIGestureRecognizer**子类对象就会和其他的**UIGestureRecognizer**子类对象共享**UITouch**对象。

```objective-c
#pragma mark - UIGestureRecognizerDelegate
// 默认情况下，UIGestureRecognize 对象在识别出特定的手势时，会“吃掉”所有和该手势有关的 UItouch 对象
// 让 UILongPressGestureRecognizer 长按手势和 UIPanGestureRecognizer 拖动手势同时被识别
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}
```

> 在**HQLDrawView.m**中实现```moveLine：```方法：


```objective-c
- (void) moveLine:(UIPanGestureRecognizer *)gr {
    // 如果没有选中的线条就直接返回
    if (! self.selectedLine) {
        return;
    }
    
    // 如果菜单项可见，返回
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.isMenuVisible ) {
        return;
    }
    
    // 如果 UIPanGestureRecognizer 对象处于“变化后”状态
    if (gr.state == UIGestureRecognizerStateChanged) {
        // 获取手指的拖移距离
        CGPoint translation = [gr translationInView:self];
        // 将拖移距离加至选中的线条的起点和终点
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        // 为选中的线段设置新的起点和和终点
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        // 重画视图
        [self setNeedsDisplay];
        // 使该对象增量地报告拖移距离
        // ：将手指的当前位置设置为拖移手势的起始位置
        [gr setTranslation:CGPointZero inView:self];
    }
}
```
