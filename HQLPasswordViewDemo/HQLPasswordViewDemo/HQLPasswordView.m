//
//  HQLPasswordView.m
//  HQLPasswordViewDemo
//
//  Created by ToninTech on 2017/6/19.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLPasswordView.h"
#import "HQLConst.h"
#import "UIView+Extension.h"

static const NSUInteger KPasswordNumber = 6;

@interface HQLPasswordView () <UITextFieldDelegate>

/** 蒙板 */
@property (nonatomic, strong) UIControl *coverView;
@property (nonatomic, strong) HQLPasswordBackgroundView *backgroundView;
@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic, strong) UIImageView *rotationImageView;
@property (nonatomic, strong) UILabel *loadingTextLabel;

@end

@implementation HQLPasswordView


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:HQLScreen.bounds];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.coverView];
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.pwdTextField];
    [self.backgroundView addSubview:self.rotationImageView];
    [self.backgroundView addSubview:self.loadingTextLabel];
    // 添加点击事件
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                initWithTarget:self
                                action:@selector(tap:)]];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // 调整旋转图片布局
    self.rotationImageView.centerX = self.backgroundView.centerX;
    self.rotationImageView.centerY = self.backgroundView.height * 0.5;
    
    // 调整提示文本布局
    self.loadingTextLabel.centerX = self.backgroundView.centerX;
    self.loadingTextLabel.y = self.rotationImageView.maxY + 20;
}


#pragma mark - Custom Accessors

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.backgroundView.title = title;
}

- (void)setLoadingText:(NSString *)loadingText {
    _loadingText = [loadingText copy];
    self.loadingTextLabel.text = loadingText;
}

- (UIControl *)coverView {
    if (!_coverView) {
        _coverView = [[UIControl alloc] init];
        _coverView.frame = self.bounds;
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.4;
    }
    return _coverView;
}

- (HQLPasswordBackgroundView *)backgroundView {
    WS(weakself);
    if (!_backgroundView) {
        _backgroundView = [[HQLPasswordBackgroundView alloc] init];
        
        _backgroundView.closeBlock = ^{
            [weakself closeButtonDidClicked];
        };
        _backgroundView.forgetPasswordBlock = ^{
            [weakself forgetPwdButtonDidClicked];
        };
    }
    return _backgroundView;
}

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
        _pwdTextField.frame = [self.backgroundView textFieldRect];
        _pwdTextField.backgroundColor = [UIColor clearColor];
        _pwdTextField.textColor = [UIColor clearColor];
        _pwdTextField.tintColor = [UIColor clearColor];
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        _pwdTextField.delegate = self;
    }
    return _pwdTextField;
}

- (UIImageView *)rotationImageView {
    if (!_rotationImageView) {
        UIImage *image =
            [UIImage imageNamed:HQLPasswordViewSrcName(@"password_loading_a")];
        _rotationImageView = [[UIImageView alloc] initWithImage:image];
        [_rotationImageView sizeToFit];
        _rotationImageView.hidden = YES;
    }
    return _rotationImageView;
}

- (UIView *)loadingTextLabel {
    if (!_loadingTextLabel) {
        _loadingTextLabel = [[UILabel alloc] init];
        _loadingTextLabel.text = @"正在确认密码...";
        _loadingTextLabel.textColor = [UIColor darkGrayColor];
        _loadingTextLabel.font = HQLLabelFont;
        _loadingTextLabel.textAlignment = NSTextAlignmentCenter;
        [_loadingTextLabel sizeToFit];
        _loadingTextLabel.hidden = YES;
    }
    return _loadingTextLabel;
}


#pragma mark - IBActions

- (void)closeButtonDidClicked {
    [self removePasswordView];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)forgetPwdButtonDidClicked {
    [self removePasswordView];
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
}


#pragma mark - Public

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    // 输入框起始frame
    // 如果是 iPhoneX，高度再增加 64
    CGFloat addHeight = [self isiPhoneX] ? 64 : 0;
    
    self.backgroundView.frame = CGRectMake(0,
                                           HQLScreenHeight,
                                           HQLScreenWidth,
                                           HQLPasswordInputViewHeight + addHeight);
    [self.pwdTextField becomeFirstResponder];
    // 输入框弹出动画
    [UIView animateWithDuration:HQLPasswordViewAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
            self.backgroundView.y = (self.height - self.backgroundView.height);
                     } completion:nil];
}

- (void)removePasswordView {
    [self.pwdTextField resignFirstResponder];
    [self removeFromSuperview];
}

- (void)startLoading {
    [self startRotation:self.rotationImageView];
    self.pwdTextField.userInteractionEnabled = NO;
    [self.backgroundView enableAllButton:NO];
}

- (void)stopLoading {
    [self stopRotation:self.rotationImageView];
}

- (void)requestComplete:(BOOL)state message:(NSString *)message {
    [self stopLoading];
    if (state) {
        // 请求成功
        self.loadingTextLabel.text = message;
        self.rotationImageView.image =
            [UIImage imageNamed:HQLPasswordViewSrcName(@"password_success")];
    } else {
        // 请求失败
        self.loadingTextLabel.text = message;
        self.rotationImageView.image =
            [UIImage imageNamed:HQLPasswordViewSrcName(@"password_error")];
        
        self.pwdTextField.userInteractionEnabled = YES;
        [self.backgroundView enableAllButton:YES];
    }
}

- (void)requestComplete:(BOOL)state {
    if (state) {
        [self requestComplete:state message:@"支付成功"];
    } else {
        [self requestComplete:state message:@"支付失败"];
    }
}


#pragma mark - Private

/** 
 用户点击事件,触摸灰色蒙版区域，实现关闭操作
 */
- (void)tap:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    CGRect frame = CGRectMake(0,
                              0,
                              HQLScreenWidth,
                              HQLScreenHeight - HQLPasswordInputViewHeight);
    // 判断点击区域是否包含在蒙版矩形中
    if (CGRectContainsPoint(frame, point)) {
        [self removePasswordView];
    }
}

// 开始旋转
- (void)startRotation:(UIView *)view {
    self.rotationImageView.hidden = NO;
    self.loadingTextLabel.hidden  = NO;
    self.rotationImageView.image =
        [UIImage imageNamed:HQLPasswordViewSrcName(@"password_loading_a")];
    self.loadingTextLabel.text = _loadingText;
    
    CABasicAnimation* rotationAnimation =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

// 结束旋转
- (void)stopRotation:(UIView *)view {
    [view.layer removeAllAnimations];
}

// 清除密码
- (void)clearUpPassword {
    // 1.清空输入文本框密码
    self.pwdTextField.text = @"";
    // 2.清空黑色圆点
    [self.backgroundView resetDotsWithLength:0];
    // 3.隐藏加载图片和文字
    self.rotationImageView.hidden = YES;
    self.loadingTextLabel.hidden  = YES;
}

// 根据设备型号调整高度，+ 64 ？
- (BOOL)isiPhoneX {
    // 先判断当前设备是否为 iPhone 或 iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // 获取屏幕的高度
        CGFloat screenHeight = HQLScreenHeight;
        if (screenHeight == 812.0f || screenHeight == 896.0f) {
            return YES;
        }
    }
    return NO;
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 每次 TextField 开始编辑，都要清空密码
    [self clearUpPassword];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSUInteger numberLength = textField.text.length + string.length;
    
    if([string isEqualToString:@""]) {
        // 1.判断是不是删除键？
        [self.backgroundView resetDotsWithLength:numberLength - 1];
        return YES;
    } else if(numberLength >= KPasswordNumber) {
        // 2.判断此次输入数字的是不是第6个数字？
        [self.backgroundView resetDotsWithLength:numberLength];
        // 2.1 收起键盘
        [self.pwdTextField resignFirstResponder];
        // 2.2 发起请求 Block
        if (self.finishBlock) {
            [self startLoading];
            NSString *password =
                [textField.text stringByAppendingString:string];
            self.finishBlock(password);
        }
        return NO;
    } else {
        // 3.每次键入一个值，都要重设黑点
        [self.backgroundView resetDotsWithLength:numberLength];
        return YES;
    }
}

@end
