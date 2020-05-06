//
//  HQLDrawView.m
//  TouchTracker
//
//  Created by ToninTech on 2016/10/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLDrawView.h"
#import "HQLLine.h"

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

// UIGestureRecognize 子类 - UIPanGestureRecognizer
// 4️⃣ 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;

@end

@implementation HQLDrawView

#pragma mark - Init Method

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        
        // 支持多点触控
        self.multipleTouchEnabled = YES;
        
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
        // 只有双击手势识别失败后，才能再去识别 UIResponder 消息
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        // 2️⃣ 单击手势
        UITapGestureRecognizer *tapRecognizer =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tap:)];
        // 同样设置手势优先：① 延迟 UIView 收到 UIResponder 消息
        tapRecognizer.delaysTouchesBegan = YES;
        // ② 需要双击手势识别失败时再识别单击手势
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        // -----------------------------------------------
        // UIGestureRecognize 子类 - UILongPressGestureRecognizer
        // 3️⃣ 长按手势
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(longPress:)];
        // UILongPressGestureRecognizer 对象默认会将持续时间超过 0.5秒的触摸事件识别为长按手势
        // 设置 minimumPressDuration 属性可修改该时间
        pressRecognizer.minimumPressDuration = 0.6;
        [self addGestureRecognizer:pressRecognizer];
        
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
    }
    return self;
}

#pragma mark 画线方法

- (void) strokeLine:(HQLLine *)line {
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect {
    
    // 用黑色绘制画好的线条
    [[UIColor blackColor] set];
    for (HQLLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    // 用红色绘制正在画的线条
   [[UIColor colorWithRed:255/255.0 green:95/255.0 blue:154/255.0 alpha:1.0] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    // 用浅蓝色绘制选中的线条
    [[UIColor colorWithRed:141/255.0 green:218/255.0 blue:247/255.0 alpha:1.0] set];
    if (self.selectedLine) {
        [self strokeLine:self.selectedLine];
    }
}


#pragma mark - UIResponder Methods

/**
 *  触摸事件
 *  
 *  因为 UIView 是 UIResponder 的子类
 *  覆盖以下四个方法可以处理不同的触摸事件
 */

#pragma mark 一根手指或多根手指触摸屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        // 根据触摸位置创建 HQLLine 对象
        CGPoint location = [t locationInView:self];
        HQLLine *line = [[HQLLine alloc] init];
        line.begin = location;
        line.end   = location;
        /**
         💡 valueWithNonretainedObject：将 UITouch 对象的内存地址封装为 NSValue 对象
         
          使用内存地址分辨 UITouch 对象的原因是，在触摸事件开始、移动、结束的整个过程中，其内存地址不会改变，
          内存地址相同的 UITouch 对象一定是同一个对象。
         */
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        // 保存当前线到字典中，key 值是 UITouch 实例对象的内存地址，value 值是 HQLLine 对象
        self.linesInProgress[key] = line;
    }
    [self setNeedsDisplay];
}

#pragma mark 一根手指或多根手指在屏幕上移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        HQLLine *line = self.linesInProgress[key];
        // 将所有绘制完成的线，即 HQLLine 对象添加到 _finishedLines 数组中
        [self.finishedLines addObject:line];
        // 从当前线中移除 HQLLine 对象
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

#pragma mark 在触摸操作正常结束前，某个系统事件打断了触摸进程
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //向控制台输出日志，查看触摸事件发生顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        // 从当前线中移除 HQLLine 对象
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}


#pragma mark - UIGestureRecognizerDelegate
// 默认情况下，UIGestureRecognize 对象在识别出特定的手势时，会“吃掉”所有和该手势有关的 UItouch 对象
// 让 UILongPressGestureRecognizer 长按手势和 UIPanGestureRecognizer 拖动手势同时被识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

#pragma mark - 双击手势方法：删除所有线条

- (void)doubleTap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized Double Tap");
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - 单击手势

- (void)tap:(UIGestureRecognizer *)gr {
    
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
- (HQLLine *)lineAtPoint:(CGPoint) p {
    
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

- (void)deleteLine:(id) sender {
    // 从已经完成的线条中删除选中的线条
    [self.finishedLines removeObject:self.selectedLine];
    // 重画整个视图
    [self setNeedsDisplay];
}

#pragma mark - 长按手势方法

- (void)longPress:(UIGestureRecognizer *)gr {
    
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

#pragma mark 拖动手势

- (void)moveLine:(UIPanGestureRecognizer *)gr {
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

// 要显示 UIMenuController 对象的 UIView 对象必须是当前窗口 UIWindow 对象的第一响应者
// 如果要将某个自定义的 UIView 子类对象设置为第一响应者 [self becomeFirstResponder]，就必须覆盖该方法。
- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
