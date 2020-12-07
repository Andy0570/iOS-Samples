//
//  WRCustomNavigationBar.h
//  CodeDemo
//
//  Created by wangrui on 2017/10/22.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import <UIKit/UIKit.h>

@interface WRCustomNavigationBar : UIView

@property (nonatomic, copy) void(^onClickLeftButton)(void);
@property (nonatomic, copy) void(^onClickRightButton)(void);

@property (nonatomic, copy)   NSString *title;              // 标题
@property (nonatomic, strong) UIColor  *titleLabelColor;    // 标题文本颜色
@property (nonatomic, strong) UIFont   *titleLabelFont;     // 标题字体
@property (nonatomic, strong) UIColor  *barBackgroundColor; // 背景颜色
@property (nonatomic, strong) UIImage  *barBackgroundImage; // 背景图片

+ (instancetype)CustomNavigationBar;

- (void)wr_setBottomLineHidden:(BOOL)hidden;
- (void)wr_setBackgroundAlpha:(CGFloat)alpha;
- (void)wr_setTintColor:(UIColor *)color;

// 默认返回事件
//- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor;
//- (void)wr_setLeftButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor;
- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)wr_setLeftButtonWithImage:(UIImage *)image;
- (void)wr_setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

//- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor;
//- (void)wr_setRightButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor;
- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)wr_setRightButtonWithImage:(UIImage *)image;
- (void)wr_setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;

@end
