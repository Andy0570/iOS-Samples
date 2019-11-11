//
//  HQLPasswordBackgroundView.m
//  HQLPasswordViewDemo
//
//  Created by ToninTech on 2017/6/19.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLPasswordBackgroundView.h"
#import "UIView+Extension.h"
#import "HQLConst.h"

static const NSUInteger KPasswordNumber = 6;

@interface HQLPasswordBackgroundView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *forgetPwdButton;
@property (nonatomic, strong) NSMutableArray *dotsImgArray;

@end

@implementation HQLPasswordBackgroundView


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.forgetPwdButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置【标题】的坐标
    self.titleLabel.centerX = HQLScreenWidth * 0.5;
    self.titleLabel.centerY = HQLPasswordViewTitleHeight * 0.5;
    
    // 设置【关闭按钮】的坐标
    self.closeButton.width  = HQLPasswordViewCloseButtonWH;
    self.closeButton.height = HQLPasswordViewCloseButtonWH;
    self.closeButton.x = HQLPasswordViewCloseButtonMarginLeft;
    self.closeButton.centerY = HQLPasswordViewTitleHeight * 0.5;
    
    // 设置【忘记密码】按钮的坐标
    self.forgetPwdButton.x = HQLScreenWidth - (HQLScreenWidth - HQLPasswordViewTextFieldWidth) * 0.5 - self.forgetPwdButton.width;
    self.forgetPwdButton.y = HQLPasswordViewTitleHeight + HQLPasswordViewTextFieldMarginTop + HQLPasswordViewTextFieldHeight + HQLPasswordViewForgetPWDButtonMarginTop;
}

- (void)drawRect:(CGRect)rect {
    // 画背景视图
    UIImage *backgroundImage =
        [UIImage imageNamed:HQLPasswordViewSrcName(@"password_background")];
    [backgroundImage drawInRect:rect];
    
    // 画输入框
    UIImage *imgTextField =
        [UIImage imageNamed:HQLPasswordViewSrcName(@"password_textfield")];
    [imgTextField drawInRect:[self textFieldRect]];
}


#pragma mark - Custom Accessors

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"输入交易密码";
        _titleLabel.font = HQLFontB(18);
        _titleLabel.textColor = HQLColor(102, 102, 102);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImage =
        [UIImage imageNamed:HQLPasswordViewSrcName(@"password_close")];
        [_closeButton setBackgroundImage:backgroundImage
                                forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(closeButtonDidClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)forgetPwdButton {
    if (!_forgetPwdButton) {
        _forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetPwdButton setTitleColor:HQLColor(47, 112, 225)
                               forState:UIControlStateNormal];
        _forgetPwdButton.titleLabel.font = HQLLabelFont;
        [_forgetPwdButton sizeToFit];
        [_forgetPwdButton addTarget:self
                             action:@selector(forgetPwdButtonDidClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdButton;
}

- (NSMutableArray *)dotsImgArray {
    if (!_dotsImgArray) {
        _dotsImgArray = [NSMutableArray arrayWithCapacity:KPasswordNumber];
        for (int i = 0; i < KPasswordNumber; i++) {
            
            // textField 的 Rect
            CGFloat textFieldW = HQLPasswordViewTextFieldWidth;
            CGFloat textFieldH = HQLPasswordViewTextFieldHeight;
            CGFloat textFieldX = (HQLScreenWidth - textFieldW) * 0.5;
            CGFloat textFieldY = HQLPasswordViewTitleHeight + HQLPasswordViewTextFieldMarginTop;
           
            // 圆点 的 Rect
            CGFloat pointW = HQLPasswordViewPointnWH;
            CGFloat pointH = HQLPasswordViewPointnWH;
            CGFloat pointY = textFieldY + (textFieldH - pointH) * 0.5;
            // 一个格子的宽度
            CGFloat cellW = textFieldW / KPasswordNumber;
            CGFloat padding = (cellW - pointW) * 0.5;
            // 圆点的 X
            CGFloat pointX = textFieldX + (2 * i + 1) * padding + i * pointW;
            // 添加圆形图片
            UIImage *dotsImage =
                [UIImage imageNamed:HQLPasswordViewSrcName(@"password_point")];
            UIImageView *dotsImageView =
                [[UIImageView alloc] initWithImage:dotsImage];
            dotsImageView.contentMode = UIViewContentModeScaleAspectFit;
            dotsImageView.frame = CGRectMake(pointX, pointY, pointW, pointH);
            // 先全部隐藏
            dotsImageView.hidden = YES;
            
            [self addSubview:dotsImageView];
            [_dotsImgArray addObject:dotsImageView];
        }
    }
    return _dotsImgArray;
}


#pragma mark - IBActions

- (void)closeButtonDidClicked:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)forgetPwdButtonDidClicked:(id)sender {
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
}


#pragma mark - Public

// 重置圆点
- (void)resetDotsWithLength:(NSUInteger)length {
    for (int i = 0; i < self.dotsImgArray.count; i++) {
        if (length == 0 || i >= length) {
            ((UIImageView *)[self.dotsImgArray objectAtIndex:i]).hidden = YES;
        }else {
            ((UIImageView *)[self.dotsImgArray objectAtIndex:i]).hidden = NO;
        }
    }
}

- (void)enableAllButton:(BOOL)enable {
    self.closeButton.userInteractionEnabled     = enable;
    self.forgetPwdButton.userInteractionEnabled = enable;
}

- (CGRect)textFieldRect {
    CGFloat textFieldW = HQLPasswordViewTextFieldWidth;
    CGFloat textFieldH = HQLPasswordViewTextFieldHeight;
    CGFloat textFieldX = (HQLScreenWidth - textFieldW) * 0.5;
    CGFloat textFieldY = HQLPasswordViewTitleHeight + HQLPasswordViewTextFieldMarginTop;
    return CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
}

@end
