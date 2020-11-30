//
//  NewUILabel.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "NewUILabel.h"

@implementation NewUILabel

// 重载父类的绘图方法，这样就可以从底层自定义标签
// 如果你需要执行自定义绘图，只需要覆盖 drawRect：方法
// 一个空的实现在动画过程中会影响性能。
- (void)drawRect:(CGRect)rect {
    // 获取图形的上下文
    CGContextRef c = UIGraphicsGetCurrentContext();
    // 设置在上下文中，文字的渲染模式为描边模式
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    
    // 设置文字描边的边框宽度
    CGContextSetLineWidth(c, 2.0);
    // 设置文字描边顶点连接方式
    CGContextSetLineJoin(c, kCGLineJoinRound);
    // 设置文字的描边颜色：白色
    self.textColor = [UIColor whiteColor];
    // 将文字的描边，绘制在指定区域内
    [super drawTextInRect:rect];
    
    // 设置上下文文字渲染模式为填充
    CGContextSetTextDrawingMode(c, kCGTextFill);
    // 创建一个颜色为黑色的颜色对象
    UIColor *textColor = [UIColor blackColor];
    // 设置文字颜色为黑色
    self.textColor = textColor;
    // 将文字的填充，绘制在指定区域内
    [super drawRect:rect];
}

@end
