//
//  HQLPasswordsView.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/7/18.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLPasswordsView.h"
#import <YYKit.h>
#import <Masonry.h>
#import "HQLConst.h"

// 默认输入密码位数，6位密码
static const NSUInteger KPasswordNumber = 6;

@interface HQLPasswordsView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *textFieldImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *forgetPwdButton;
@property (nonatomic, strong) UIImageView *rotationImageView;
@property (nonatomic, strong) UILabel *loadingTextLabel;
@property (nonatomic, strong) NSMutableArray *dotsImgArray;

@end

@implementation HQLPasswordsView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.closeButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.line];
    [self addSubview:self.textFieldImageView];
    [self addSubview:self.pwdTextField];
    [self addSubview:self.forgetPwdButton];
    [self addSubview:self.rotationImageView];
    [self addSubview:self.loadingTextLabel];
    
    [self addDefaultBlackRoundDots];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(13);
        make.left.equalTo(self).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.closeButton.mas_centerY);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.top.mas_equalTo(self.closeButton.mas_bottom).with.offset(13);
        make.height.mas_equalTo(1);
    }];
    [self.textFieldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(30);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(297, 50));
    }];
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.textFieldImageView);
    }];
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTextField.mas_bottom).with.offset(12);
        make.right.equalTo(self.pwdTextField.mas_right);
    }];
    [self.rotationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self.forgetPwdButton.mas_bottom).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.loadingTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.rotationImageView.mas_bottom).with.offset(20);
    }];

    [super updateConstraints];
}

#pragma mark - Custom Accessors

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
}

- (void)setLoadingText:(NSString *)loadingText {
    _loadingText = [loadingText copy];
    self.loadingTextLabel.text = loadingText;
    [self.loadingTextLabel sizeToFit];
}

- (void)setCloseButtonImage:(NSString *)closeButtonImage {
    _closeButtonImage = [closeButtonImage copy];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:closeButtonImage]
                                forState:UIControlStateNormal];
}

// 输入框占位图片
- (UIImageView *)textFieldImageView {
    if (!_textFieldImageView) {
        _textFieldImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_textField"]];
    }
    return _textFieldImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请输入密码";
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:249/255.0f green:249/255.0f blue:249/255.0f alpha:1.0];
    }
    return _line;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"password_back"];
        [_closeButton setBackgroundImage:image
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
        [_forgetPwdButton setTitleColor:[UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0]
                               forState:UIControlStateNormal];
        _forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgetPwdButton sizeToFit];
        [_forgetPwdButton addTarget:self
                             action:@selector(forgetPwdButtonDidClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdButton;
}

- (UITextField *)pwdTextField {
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] init];
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
        UIImage *image = [UIImage imageNamed:@"password_loading_a"];
        _rotationImageView = [[UIImageView alloc] initWithImage:image];
        _rotationImageView.hidden = YES;
    }
    return _rotationImageView;
}

- (UIView *)loadingTextLabel {
    if (!_loadingTextLabel) {
        _loadingTextLabel = [[UILabel alloc] init];
        _loadingTextLabel.text = @"确认密码...";
        _loadingTextLabel.textColor = [UIColor darkGrayColor];
        _loadingTextLabel.font = [UIFont systemFontOfSize:14];
        _loadingTextLabel.textAlignment = NSTextAlignmentCenter;
        _loadingTextLabel.hidden = YES;
    }
    return _loadingTextLabel;
}

- (NSMutableArray *)dotsImgArray {
    if (!_dotsImgArray) {
        _dotsImgArray = [NSMutableArray arrayWithCapacity:KPasswordNumber];
    }
    return _dotsImgArray;
}

#pragma mark - IBActions

- (void)closeButtonDidClicked:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
    self.closeBlock = nil;
}

- (void)forgetPwdButtonDidClicked:(id)sender {
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
    self.forgetPasswordBlock = nil;
}

#pragma mark - Public

- (void)requestComplete:(BOOL)state message:(NSString *)message {
    [self stopLoading];
    if (state) {
        // 请求成功
        self.loadingTextLabel.text = message;
        self.rotationImageView.image = [UIImage imageNamed:@"password_success"];
    } else {
        // 请求失败
        self.loadingTextLabel.text = message;
        self.rotationImageView.image = [UIImage imageNamed:@"password_error"];
    }
    [self.loadingTextLabel sizeToFit];
}

- (void)requestComplete:(BOOL)state {
    if (state) {
        [self requestComplete:state message:@"支付成功"];
    } else {
        [self requestComplete:state message:@"支付失败"];
    }
}

#pragma mark - Private

- (void)addDefaultBlackRoundDots {
    for (int i = 0; i < KPasswordNumber; i++) {
        // textField 的 Rect
        CGRect textFieldRect = self.textFieldImageView.frame;
        
//        CGFloat textFieldX = CGRectGetMinX(textFieldRect);
//        CGFloat textFieldY = CGRectGetMinY(textFieldRect);
        CGFloat textFieldX = 40;
        CGFloat textFieldY = 64;
        CGFloat textFieldW = CGRectGetWidth(textFieldRect);
        CGFloat textFieldH = CGRectGetHeight(textFieldRect);
        
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
        UIImageView *dotsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_point"]];
        dotsImageView.contentMode = UIViewContentModeCenter;
        dotsImageView.frame = CGRectMake(pointX, pointY, pointW, pointH);
        // 先全部隐藏
        dotsImageView.hidden = YES;
        
        [self addSubview:dotsImageView];
        [self.dotsImgArray addObject:dotsImageView];
    }
}

// 重置圆点
- (void)resetDotsWithLength:(NSUInteger)length {
    for (int i = 0; i < KPasswordNumber; i++) {
        if (length == 0 || i >= length) {
            ((UIImageView *)[self.dotsImgArray objectAtIndex:i]).hidden = YES;
        }else {
            ((UIImageView *)[self.dotsImgArray objectAtIndex:i]).hidden = NO;
        }
    }
}

// 开始旋转
- (void)startLoading {
    [self startRotation:self.rotationImageView];
    self.pwdTextField.userInteractionEnabled = NO;
    [self enableAllButton:NO];
}

- (void)enableAllButton:(BOOL)enable {
    self.closeButton.userInteractionEnabled     = enable;
    self.forgetPwdButton.userInteractionEnabled = enable;
}

// 结束旋转
- (void)stopLoading {
    [self stopRotation:self.rotationImageView];
    self.pwdTextField.userInteractionEnabled = YES;
    [self enableAllButton:YES];
}

- (void)startRotation:(UIView *)view {
    self.rotationImageView.hidden = NO;
    self.loadingTextLabel.hidden  = NO;
    self.rotationImageView.image = [UIImage imageNamed:@"password_loading_a"];
    self.loadingTextLabel.text = _loadingText;
    [self.loadingTextLabel sizeToFit];
    
    CABasicAnimation* rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRotation:(UIView *)view {
    [view.layer removeAllAnimations];
}

// 清除密码
- (void)clearUpPassword {
    // 1.清空输入文本框密码
    self.pwdTextField.text = @"";
    // 2.清空黑色圆点
    [self resetDotsWithLength:0];
    // 3.隐藏加载图片和文字
    self.rotationImageView.hidden = YES;
    self.loadingTextLabel.hidden  = YES;
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
        [self resetDotsWithLength:numberLength - 1];
        return YES;
    } else if(numberLength >= KPasswordNumber) {
        // 2.判断此次输入数字的是不是第6个数字？
        [self resetDotsWithLength:numberLength];
        // 2.1 收起键盘
        [self.pwdTextField resignFirstResponder];
        // 2.2 发起请求 Block
        if (self.finishBlock) {
            [self startLoading];
            NSString *password =
            [textField.text stringByAppendingString:string];
            self.finishBlock(password);
        }
        self.finishBlock = nil;
        return NO;
    } else {
        // 3.每次键入一个值，都要重设黑点
        [self resetDotsWithLength:numberLength];
        return YES;
    }
}

@end
