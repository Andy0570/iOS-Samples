//
//  HQLPictureView.m
//  HQLHyponsister
//
//  Created by ToninTech on 16/8/22.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLPictureView.h"

@implementation HQLPictureView

// 插入图片，绘制图像
- (void) drawRect:(CGRect)rect {
    
    UIImage *myImage = [UIImage imageNamed:@"iPhone6.png"];
    // 将图像绘制到视图上
    [myImage drawInRect:CGRectMake(0, 0, 414, 736)];
    
}

@end
