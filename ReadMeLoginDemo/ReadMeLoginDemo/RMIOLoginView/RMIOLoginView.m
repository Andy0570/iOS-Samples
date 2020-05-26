//
//  RMIOLoginView.m
//  ReadMeLoginDemo
//
//  Created by Qilin Hu on 2018/1/18.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "RMIOLoginView.h"

// frameworks
#import <YYKit.h>

// 猫头鹰动画
typedef NS_ENUM(NSUInteger, RMIOLoginViewOwlAnimationState) {
    RMIOLoginViewOwlAnimationStateDefaule, // 默认初始状态
    RMIOLoginViewOwlAnimationStateDown,    // 睁眼状态（输入用户名时）
    RMIOLoginViewOwlAnimationStateUp,      // 遮眼状态（输入密码时）
};

static NSTimeInterval KOwlAnimationDuration = 0.3;
static NSInteger KUsernameTextFieldTag = 5701;
static NSInteger KPasswordTextFieldTag = 5702;


@interface RMIOLoginView () <UITextFieldDelegate>

@property (nonatomic, copy) RMIOLoginButtonClickedHandle buttonClickedBlock;
@property (nonatomic, assign) RMIOLoginViewOwlAnimationState owlAnimationState;

@property (nonatomic, strong) UIView *loginContainerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIImageView *owlEyeImgView;
@property (nonatomic, strong) UIImageView *armDownLeftImgView;
@property (nonatomic, strong) UIImageView *armDownRightImgView;
@property (nonatomic, strong) UIImageView *armUpLeftImgView;
@property (nonatomic, strong) UIImageView *armUpRightImgView;

@property (nonatomic, assign) CGRect faceRect;

@end

@implementation RMIOLoginView

#pragma mark - Lifecycle

- (instancetype)initWithLoginButtonClickedHandle:(RMIOLoginButtonClickedHandle)buttonClickedBlock {
    self = [super init];
    if (self) {
        _buttonClickedBlock = buttonClickedBlock;
        [self addSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (instancetype)init {
    return [self initWithLoginButtonClickedHandle:nil];
}

#pragma mark - Custom Accessors

// 登录页面容器视图：包含标题、用户名输入框、密码输入框、登录按钮
- (UIView *)loginContainerView {
    if (!_loginContainerView) {
        _loginContainerView = [[UIView alloc] initWithFrame:CGRectMake(20, 150, kScreenWidth - 40, 215)];
        _loginContainerView.backgroundColor = [UIColor whiteColor];
        _loginContainerView.layer.cornerRadius = 5;
        _loginContainerView.layer.masksToBounds = NO;
    }
    return _loginContainerView;
}

// 标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.loginContainerView.width - 20, 20)];
        _titleLabel.text = @"readme";
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

// 用户名输入框
- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame) + 15, self.loginContainerView.width - 40, 40)];
        // 设置圆角边框
        _usernameTextField.borderStyle = UITextBorderStyleRoundedRect;

        _usernameTextField.placeholder = @"请输入账号";
        _usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _usernameTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _usernameTextField.returnKeyType = UIReturnKeyDone;
        _usernameTextField.enablesReturnKeyAutomatically = YES;
        _usernameTextField.delegate = self;
        _usernameTextField.tag = KUsernameTextFieldTag;
        // 设置左侧图片
        CGFloat height = CGRectGetHeight(_usernameTextField.frame);
        _usernameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
        _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 22, 22)];
        imgView.image = [UIImage imageNamed:@"textField-username"];
        [_usernameTextField.leftView addSubview:imgView];
    }
    return _usernameTextField;
}

// 密码输入框
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.usernameTextField.frame) + 10, CGRectGetWidth(self.usernameTextField.frame), 40)];
        // 设置圆角边框
        _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.enablesReturnKeyAutomatically = YES;
        _passwordTextField.delegate = self;
        _passwordTextField.tag = KPasswordTextFieldTag;
        // 设置左侧图片
        CGFloat height = CGRectGetHeight(_passwordTextField.frame);
        _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;

        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 22, 22)];
        imgView.image = [UIImage imageNamed:@"textField-password"];
        [_passwordTextField.leftView addSubview:imgView];
    }
    return _passwordTextField;
}

// 登录按钮
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginButton.frame = CGRectMake(20, CGRectGetMaxY(self.passwordTextField.frame) + 20, CGRectGetWidth(self.usernameTextField.frame), 40);
        NSDictionary *parameters = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:18],
                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"登录" attributes:parameters];
        [_loginButton setAttributedTitle:title forState:UIControlStateNormal];
        // 设置圆角
        _loginButton.layer.cornerRadius = 5;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorNamed:@"login_btn_normal"]]
                                forState:UIControlStateNormal];
        [_loginButton addTarget:self
                         action:@selector(loginButtonDidClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

#pragma mark - IBActions

- (void)loginButtonDidClicked:(id)sender {
    [self endEditing:YES];
    
    if (_buttonClickedBlock) {
        _buttonClickedBlock(self.usernameTextField.text, self.passwordTextField.text);
    }
}

#pragma mark - Private

// 初始化并添加子视图
- (void)addSubviews {
    
    self.backgroundColor = [UIColor colorNamed:@"login_bg_white"];
    
    // 蓝色背景视图
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    backgroundView.backgroundColor = [UIColor colorNamed:@"login_bg_blue"];
    [self addSubview:backgroundView];
    
    // 登录容器视图
    [self addSubview:self.loginContainerView];
    [self.loginContainerView addSubview:self.titleLabel];
    [self.loginContainerView addSubview:self.usernameTextField];
    [self.loginContainerView addSubview:self.passwordTextField];
    [self.loginContainerView addSubview:self.loginButton];
    
    // 猫头鹰脸 116*92
    self.faceRect = CGRectMake(CGFloatPixelRound((kScreenWidth - 116) / 2), 69, 116, 92);
    UIImageView *owlFaceImgView = [[UIImageView alloc] initWithFrame:_faceRect];
    owlFaceImgView.image = [UIImage imageNamed:@"face"];
    [self addSubview:owlFaceImgView];
    
    // 猫头鹰眼睛
    self.owlEyeImgView = [[UIImageView alloc] initWithFrame:_faceRect];
    self.owlEyeImgView.image = [UIImage imageNamed:@"eyes"];
    self.owlEyeImgView.alpha = 0;
    [self addSubview:self.owlEyeImgView];
    
    // 放下时的左右手
    CGRect armDownLeftRect = CGRectMake(_faceRect.origin.x - 43 + 7, 134, 43, 25);
    self.armDownLeftImgView = [[UIImageView alloc] initWithFrame:armDownLeftRect];
    self.armDownLeftImgView.image = [UIImage imageNamed:@"arm-down-left"];
    [self addSubview:self.armDownLeftImgView];
    
    CGRect armDownRightRect = CGRectMake(CGRectGetMaxX(_faceRect), 134, 43, 26);
    self.armDownRightImgView = [[UIImageView alloc] initWithFrame:armDownRightRect];
    self.armDownRightImgView.image = [UIImage imageNamed:@"arm-down-right"];
    [self addSubview:self.armDownRightImgView];
    
    // 抬起时的左右手
    CGRect armUpLeftRect = CGRectMake(_faceRect.origin.x - 15, 150, 0, 0);
    self.armUpLeftImgView = [[UIImageView alloc] initWithFrame:armUpLeftRect];
    self.armUpLeftImgView.image = [UIImage imageNamed:@"arm-up-left"];
    [self addSubview:self.armUpLeftImgView];
    
    CGRect armUpRightRect = CGRectMake(CGRectGetMaxX(_faceRect) + 15, 150, 0, 0);
    self.armUpRightImgView = [[UIImageView alloc] initWithFrame:armUpRightRect];
    self.armUpRightImgView.image = [UIImage imageNamed:@"arm-up-right"];
    [self addSubview:self.armUpRightImgView];
}

// 抬起左右手动画：打开双手状态 -> 遮住眼睛状态
- (void)armUpImageAnimation {
    
    [UIView animateWithDuration:KOwlAnimationDuration animations:^{
        
        self.owlEyeImgView.alpha = 1;
        
        CGRect armDownLeftRect = CGRectMake(_faceRect.origin.x +29, 148, 0, 0);
        self.armDownLeftImgView.frame = armDownLeftRect;
        CGRect armDownRightRect = CGRectMake(CGRectGetMaxX(_faceRect) - 29, 148, 0, 0);
        self.armDownRightImgView.frame = armDownRightRect;
        
        CGRect armUpLeftRect = CGRectMake(_faceRect.origin.x - 6, 108, 51, 42);
        self.armUpLeftImgView.frame = armUpLeftRect;
        CGRect armUpRightRect = CGRectMake(_faceRect.origin.x + 60, 107, 51, 43);
        self.armUpRightImgView.frame = armUpRightRect;
    }];
}

// 放下左右手动画：遮住眼睛状态->打开双手状态
- (void)armDownImageAnimation {
    [UIView animateWithDuration:KOwlAnimationDuration animations:^{
        
        self.owlEyeImgView.alpha = 0;
        
        CGRect armDownLeftRect = CGRectMake(_faceRect.origin.x - 36, 134, 43, 25);
        self.armDownLeftImgView.frame = armDownLeftRect;
        CGRect armDownRightRect = CGRectMake(CGRectGetMaxX(_faceRect), 134, 43, 26);
        self.armDownRightImgView.frame = armDownRightRect;
        
        CGRect armUpLeftRect = CGRectMake(_faceRect.origin.x - 15, 150, 0, 0);
        self.armUpLeftImgView.frame = armUpLeftRect;
        CGRect armUpRightRect = CGRectMake(CGRectGetMaxX(_faceRect) + 15, 150, 0, 0);
        self.armUpRightImgView.frame = armUpRightRect;
    }];
}

// 点击空白部分放弃第一响应者，收起键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - UITextFieldDelegate

// 开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 1.开始输入用户名
    if (textField.tag == KUsernameTextFieldTag) {
        switch (self.owlAnimationState) {
            case RMIOLoginViewOwlAnimationStateDefaule: {
                self.owlAnimationState = RMIOLoginViewOwlAnimationStateDown;
                break;
            }
            case RMIOLoginViewOwlAnimationStateDown: {
                break;
            }
            case RMIOLoginViewOwlAnimationStateUp: {
                self.owlAnimationState = RMIOLoginViewOwlAnimationStateDown;
                [self armDownImageAnimation];
                break;
            }
        }
    }
    
    // 2.开始输入密码
    if (textField.tag == KPasswordTextFieldTag) {
        switch (self.owlAnimationState) {
            case RMIOLoginViewOwlAnimationStateDefaule:
            case RMIOLoginViewOwlAnimationStateDown: {
                self.owlAnimationState = RMIOLoginViewOwlAnimationStateUp;
                [self armUpImageAnimation];
                break;
            }
            case RMIOLoginViewOwlAnimationStateUp: {
                break;
            }
        }
    }
}

/*
 结束编辑
 每当密码输入结束编辑时，需要打开双手。
 遮住眼睛->打开双手：
 * 密码输入时，返回到账号输入，打开双手。
 * 密码输入时，点击空白部分或点击登录，打开双手。
 
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == KPasswordTextFieldTag) {
        if (self.owlAnimationState == RMIOLoginViewOwlAnimationStateUp) {
            self.owlAnimationState = RMIOLoginViewOwlAnimationStateDown;
            [self armDownImageAnimation];
        }
    }
}

// 用户点击键盘"Return"按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

@end
