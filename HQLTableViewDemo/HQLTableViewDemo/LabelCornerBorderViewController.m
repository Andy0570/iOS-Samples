//
//  LabelCornerBorderViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "LabelCornerBorderViewController.h"
#import <Chameleon.h>
#import "NewUILabel.h"

@interface LabelCornerBorderViewController ()

@end

@implementation LabelCornerBorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self addLabel1];
    [self addLabel2];
    [self add3DIMAXTag];
    [self addLabelWithShadow];
    [self addNewUILabel];
}

// 圆角
- (void)addLabel1 {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(40, 100, 55, 25);
    label.text = @"影城卡";
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];

    // 优化设置圆角（推荐方法）
    // 设置 layer 的背景颜色，这样就可以避免离屏渲染问题
    label.layer.backgroundColor = HexColor(@"#62C067").CGColor;
    label.layer.cornerRadius = 5;

    [self.view addSubview:label];
}

// 圆角和边框
- (void)addLabel2 {
    // 创建 UILabel 对象
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(40, 150, 54, 25);
    label.text = @"小食";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor flatSkyBlueColor];
    // 设置圆角
    label.layer.cornerRadius = 12;
    // label.layer.masksToBounds = YES;
    // 设置边框
    label.layer.borderWidth = 1.0;
    label.layer.borderColor = [UIColor flatSkyBlueColor].CGColor;
    [self.view addSubview:label];
}

// 设置 Tag
- (void)add3DIMAXTag {
    UIView *tag = [[UIView alloc] initWithFrame:CGRectMake(40, 200, 45, 13)];
    tag.backgroundColor = rgb(185, 183, 197);
    tag.layer.borderWidth = 1;
    tag.layer.borderColor = rgb(185, 183, 197).CGColor;
    tag.layer.cornerRadius = 2;

    UILabel *leftPart = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 13)];
    leftPart.layer.borderWidth = 1;
    leftPart.layer.borderColor = rgb(185, 183, 197).CGColor;
    leftPart.layer.cornerRadius = 2;
    leftPart.backgroundColor = [UIColor clearColor];
    leftPart.text = @"3D";
    leftPart.textAlignment = NSTextAlignmentCenter;
    leftPart.textColor = [UIColor whiteColor];
    leftPart.font = [UIFont systemFontOfSize:6];

    UILabel *rightPart = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 28, 13)];
    rightPart.backgroundColor = [UIColor whiteColor];
    rightPart.text = @"IMAX";
    rightPart.textAlignment = NSTextAlignmentCenter;
    rightPart.textColor = rgb(185, 183, 197);
    rightPart.font = [UIFont systemFontOfSize:6];

    [tag addSubview:leftPart];
    [tag addSubview:rightPart];

    [self.view addSubview:tag];
}

// 设置阴影
- (void)addLabelWithShadow {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(40, 250, 125, 24);
    label.text = @"Hello World";
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor lightGrayColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    // 设置字体颜色，自适应深色模式
    if (@available(iOS 13.0, *)) {
        label.textColor = UIColor.labelColor;
    } else {
        label.textColor = [UIColor blueColor];
    }
    
    // 设置阴影颜色
    label.shadowColor = [UIColor flatBlueColor];

    // 设置阴影偏移量，默认为 CGSizeMake(0, -1) ——向上偏移
    // CGSize 宽度控制这阴影横向的位移，高度控制着纵向的位移。
    label.shadowOffset = CGSizeMake(1.5, 1.5);
    
    [self.view addSubview:label];
}

- (void)addNewUILabel {
    // 初始化一个自定义标签对象，并指定其位置和尺寸
    CGRect labelFrame = CGRectMake(40, 300, 150, 60);
    NewUILabel *label = [[NewUILabel alloc] initWithFrame:labelFrame];
    // 设置标签对象的文本内容
    label.text = @"Apple";
    // 设置文字的字体和大小
    label.font = [UIFont fontWithName:@"Arial" size:24];
    label.backgroundColor = UIColor.purpleColor;
    // 将标签对象，添加到当前视图控制器的根视图
    [self.view addSubview:label];
}

@end
