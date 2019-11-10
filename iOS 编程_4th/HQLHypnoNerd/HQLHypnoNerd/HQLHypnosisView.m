//
//  HQLHypnosisView.m
//  HQLHyponsister
//
//  Created by ToninTech on 16/8/15.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLHypnosisView.h"

/**
 *  【运行循环和重绘视图】
 *
 *  iOS应用启动时会开始一个运行循环。运行循环的工作是监听事件，当事件发生时运行循环会为相应的事件找到合适的处理方法，（类似于单片机中的中断处理）只有当调用的处理方法都执行完毕时，控制权才会再次回到运行循环。
 *  当应用将控制权交回给运行循环时，运行循环首先会检查是否有等待重绘的视图（即在当前循环收到setNeedsDisplay消息的视图），然后向所有等待重绘的视图发送drawRect：消息，最后视图层次结构中所有视图的图层再次组合成一幅完整的图像并绘制到屏幕上。
 
 *  iOS做了两方面来保证用户界面的流畅性：
 *  1. 不重绘显示的内容没有改变的视图；
 *  2. 在每次事件处理周期（event handing cycle）中只发送一次drawRect:消息。iOS会在运行循环的最后阶段集中处理所有需要重绘的视图
 */

// 在类扩展（class extensions）中声明属性和方法，表明该属性和方法只会在类的内部使用
// 子类同样无法访问父类在类扩展中声明的属性和方法
@interface HQLHypnosisView ()

@end

@implementation HQLHypnosisView

// 覆写初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        //设置HQLHyponsisView对象的背景颜色为透明
        self.backgroundColor = [UIColor clearColor];
        
        //为circleColor属性设置默认颜色
        self.circleColor = [UIColor redColor];
    }
    return self;
}

// 自定义存方法 setCircleColor：
- (void)setCircleColor:(UIColor *)circleColor {
    
    _circleColor = circleColor;
    
    // 发送视图重绘消息
    // 对于自定义的UIView子类，必须手动向其发送setNeedsDisplay消息
    [self setNeedsDisplay];
}

// 覆写绘制图形方法
- (void)drawRect:(CGRect)rect{
    
     CGRect bounds=self.bounds;
    
    //--------------------------------------
    //设置渐变
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
    
    //恢复Graphical Context图形上下文
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    
    //--------------------------------------
    //根据bounds计算中心点
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
//    //比较视图的宽和高，取较小值的1/2设置为圆半径
//    float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);
    
//    //使用UIBezierPath类绘制圆形
//    UIBezierPath *path = [[UIBezierPath alloc]init];
//    
//    //以中心点为圆心、radious的值为半径定义一个0到M_PI*2.0弧度的路径（整圆😇)
//    [path addArcWithCenter:center
//                    radius:radius
//                startAngle:0.0
//                  endAngle:M_PI*2.0
//                 clockwise:YES];
 
    //-------------------------------------
    //使最外层圆形成为视图的外接圆
    //使用视图的对角线作为最外层圆形的直径
    float maxRadius = hypot(bounds.size.width, bounds.size.height)/ 2.0;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius;
         currentRadius>0;
         currentRadius -=20)
    {
        //每次绘制新圆前，抬笔，重置起始点
        [path moveToPoint:CGPointMake(center.x +currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    //设置线条宽度为10点
    path.lineWidth = 10;
    
    //设置绘制颜色为浅灰色
    //    [[UIColor lightGrayColor] setStroke];
    
    //使用circleColor作为线条颜色
    [self.circleColor setStroke];
    
    //绘制路径
    [path stroke];
    
}

// 覆写处理触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches  anyObject];
    if (touch.tapCount ==1 ) {
        // 获取三个0到1之间的数字
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

@end
