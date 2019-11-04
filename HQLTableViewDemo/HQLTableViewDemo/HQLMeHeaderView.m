//
//  HQLMeHeaderView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/24.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLMeHeaderView.h"
#import <YYKit.h>
#import <Chameleon.h>

static const CGFloat KHeaderViewHeight = 165;

@implementation HQLMeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, KHeaderViewHeight);
        [self setBackgroundGradientColor];
    }
    return self;
}

// 设置渐变色
- (void)setBackgroundGradientColor {
    NSArray *colors = @[HexColor(@"#3E91FF"),
                        HexColor(@"#4596FF"),
                        HexColor(@"#4D9AFF"),
                        HexColor(@"#549EFF"),
                        HexColor(@"#5CA3FF")];
    UIColor *gradientColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.bounds andColors:colors];
    self.backgroundColor = gradientColor;
}

@end
