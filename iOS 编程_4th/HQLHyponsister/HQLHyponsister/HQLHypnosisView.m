//
//  HQLHypnosisView.m
//  HQLHyponsister
//
//  Created by ToninTech on 16/8/15.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLHypnosisView.h"

// 在【类扩展】（class extensions）中声明属性和方法，表明该属性和方法只会在类的内部使用
// 子类同样无法访问父类在类扩展中声明的属性和方法
@interface HQLHypnosisView ()

@property (nonatomic, strong) UIColor *circleColor;

@end

@implementation HQLHypnosisView

#pragma mark - Init

// 覆写指定初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self =[super initWithFrame:frame];
    
    if (self) {
        // 设置 HQLHyponsisView 对象的背景颜色为透明色
        self.backgroundColor = [UIColor clearColor];
        
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

#pragma mark - Custom Accessors

// 自定义 setter 方法
- (void)setCircleColor:(UIColor *)circleColor {
    
    _circleColor = circleColor;
    
    // 发送视图重绘消息
    [self setNeedsDisplay];
    
}

#pragma mark - Private 

// 当用户触摸视图时，视图会收到 touchesBegan:withEvent: 消息处理触摸事件
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

#pragma mark - Override

// 视图根据 drawRect: 方法将自己绘制到图层上。
// UIView 的子类可以覆盖 drawRect: 方法完成自定义的绘图任务
- (void)drawRect:(CGRect)rect{
    
    /*
     bounds 属性：定义了一个矩形范围，表示视图的绘制区域。
     
     bounds 表示的矩形位于自己的坐标系，
     frame  表示的矩形位于父视图的坐标系，但是两个矩形的大小是相同的。
     
     frame 和 bounds 表示的矩形用法不同。
     frame 用于确定与视图层次结构中其他视图的相对位置，从而将自己的图层与其他视图的图层正确组合成屏幕上的图像。
     bounds 属性用于确定绘制区域，避免将自己绘制到图层边界之外。
     */
     CGRect bounds = self.bounds;
    
    // ---------------设置渐变-----------------------
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
    
    
    // --------------- 绘制同心圆 -----------------------
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
    
    
    // ----------------为图片添加阴影--------------------------
    
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
    
}
@end
