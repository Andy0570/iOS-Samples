//
//  HQLGridButtonViewController.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/4/21.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLGridButtonViewController.h"

// Framework
#import "UIView+Toast.h"

// 随机颜色
#define RandomColor [UIColor colorWithDisplayP3Red:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];

@interface HQLGridButtonViewController ()

@end

@implementation HQLGridButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupGridButton];
}

// 创建九宫格布局按钮
- (void)setupGridButton {
    // 一共创建 12 个按钮，每行显示 5 个！
    for (int i = 0; i < 12 ; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        // 计算按钮之间的间隙 50*5（5个按钮每个按钮宽度为：50）/4 （5个按钮之间有4个空隙）
        CGFloat space = (self.view.frame.size.width - 20 - 50*5) /4 ;
        // X(对5取余数，不超过5个按钮) y (对5取整数，不超过2行)
        CGFloat x = i % 5;
        CGFloat y = i / 5;
        button.frame = CGRectMake(10+x*(space+50), 88+(50+20)*y, 50, 50);
        // 通过按钮的 Tag 值来区分不同的按钮
        button.tag = 1000 + i;
        [button addTarget:self
                   action:@selector(buttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = RandomColor;
        [self.view addSubview:button];
    }
}

- (void)buttonClicked :(UIButton *)button {
    NSString *message = [NSString stringWithFormat:@"被点击的按钮 Tag 值：%ld", button.tag];
    [self.view makeToast:message];
}

@end
