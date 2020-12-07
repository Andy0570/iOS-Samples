//
//  ButtonBasicUsageViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "ButtonBasicUsageViewController.h"
#import <Masonry.h>
#import <JKCategories.h>
#import <Chameleon.h>

typedef void(^ShoppingCartRadioButtonBlock)(BOOL isSelected);

@interface ButtonBasicUsageViewController ()
@property (nonatomic, strong) UIButton *showPasswordButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) UIButton *sendCaptchaButton;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, copy) ShoppingCartRadioButtonBlock radioButtonActionBlock;
@property (nonatomic, strong) UIButton *radioButton;

@end

@implementation ButtonBasicUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self addButtonType1];
    [self addButtonType2];
    [self addButtonWithBorder];
    
    // 下一步
    [self.view addSubview:self.nextButton];
    
    // 登录按钮
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(200);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    // 忘记密码
    [self.view addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    // 发送短信验证码
    [self.view addSubview:self.sendCaptchaButton];
    [self.sendCaptchaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.forgetPasswordButton.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    // 提交
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sendCaptchaButton.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    // 单选按钮
    [self.view addSubview:self.radioButton];
    [self.radioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.submitButton.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
}

/* MARK: 点击高亮效果
 * Normal: 标题 18pt #FFFFFF
 *         背景颜色   #108EE9
 * Press:  标题 18pt #FFFFFF
 *         背景颜色   #1284D6
 */
- (void)addButtonType1 {
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 默认标题
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    NSAttributedString *title =[[NSAttributedString alloc] initWithString:@"提交" attributes:attributes];
    [submitButton setAttributedTitle:title forState:UIControlStateNormal];
    
    // 设置背景颜色
    // 使用 JKCategories 方法实现将颜色生成图片效果
    [submitButton jk_setBackgroundColor:HexColor(@"#108EE9") forState:UIControlStateNormal];
    [submitButton jk_setBackgroundColor:HexColor(@"#1284D6") forState:UIControlStateHighlighted];
    
    // 设置圆角
    submitButton.clipsToBounds = YES;
    submitButton.layer.cornerRadius = 5;
    
    [submitButton addTarget:self
                     action:@selector(buttonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    // 将按钮添加到视图上
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(20);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
}

// MARK: 高亮镂空效果
- (void)addButtonType2 {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIColor *buttonThemeColor = [UIColor jk_colorWithHexString:@"#108EE9"];
    
    // 默认标题
    NSDictionary *normalAttrs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:13],
        NSForegroundColorAttributeName:buttonThemeColor
    };
    NSAttributedString *normalTitle =[[NSAttributedString alloc] initWithString:@"发送" attributes:normalAttrs];
    [button setAttributedTitle:normalTitle forState:UIControlStateNormal];
    
    // 高亮标题
    NSDictionary *highlightedAttrs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:13],
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"发送" attributes:highlightedAttrs];
    [button setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
    
    // 高亮背景颜色
    [button jk_setBackgroundColor:buttonThemeColor forState:UIControlStateHighlighted];
    
    // 圆角和边框
    button.layer.cornerRadius = 3.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = buttonThemeColor.CGColor;
    
    // Target-Action
    [button addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    // 将按钮添加到视图上
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(80);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
}

// MARK: 设置边框
- (void)addButtonWithBorder {
    // 创建一个按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    // 设置按钮的背景色:黑色
    button.backgroundColor = UIColor.blackColor;
    // 设置按钮的前景色：灰色
    button.tintColor = UIColor.grayColor;
    // 设置按钮的标签文字
    [button setTitle:@"Tap it" forState:UIControlStateNormal];
    
    // 给按钮添加边框效果
    button.layer.masksToBounds = YES;
    // 设置层的圆角半径
    button.layer.cornerRadius = 5.0f;
    // 设置边框的宽度
    button.layer.borderWidth = 2.0f;
    // 设置边框的颜色：渐变色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(colorSpace, (CGFloat[]){ 56/255.0, 237/255.0, 56/255.0, 1 });
    button.layer.borderColor = colorRef;
    
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(140);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
}

#pragma mark - Custom Accessors

- (UIButton *)showPasswordButton {
    if (!_showPasswordButton) {
        _showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordButton setImage:[UIImage imageNamed:@"login_pwd_hide"]
                             forState:UIControlStateNormal];
        [_showPasswordButton setImage:[UIImage imageNamed:@"login_pwd_show"]
                             forState:UIControlStateSelected];
        [_showPasswordButton setSelected:NO];
        [_showPasswordButton addTarget:self
                                action:@selector(buttonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}

// MARK: 下一步
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(200, 200, 100, 60);
        // 默认标题
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor colorWithRed:255/255.0 green:63/255.0 blue:71/255.0 alpha:1]
                          forState:UIControlStateNormal];
        // 设置圆角
        _nextButton.clipsToBounds = YES;
        _nextButton.layer.cornerRadius = 5;
        // Target-Action
        [_nextButton addTarget:self
                         action:@selector(buttonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

// MARK: 登录
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.enabled = YES;
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:18],
            NSForegroundColorAttributeName:[UIColor whiteColor]
        };
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"登录"
                                                                    attributes:attributes];
        [_loginButton setAttributedTitle:title forState:UIControlStateNormal];
        
        UIColor *themeColor = HexColor(@"#47c1b6");
        [_loginButton setBackgroundImage:[UIImage jk_imageWithColor:themeColor]
                                forState:UIControlStateNormal];
        UIColor *darkenColor = [themeColor darkenByPercentage:0.1f];
        [_loginButton setBackgroundImage:[UIImage jk_imageWithColor:darkenColor]
                                forState:UIControlStateHighlighted];
        _loginButton.layer.cornerRadius = 5.f;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self
                         action:@selector(buttonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

// MARK: 忘记密码
- (UIButton *)forgetPasswordButton {
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPasswordButton.backgroundColor = [UIColor whiteColor];
        // 默认标题
        NSDictionary *normalAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:15],
            NSForegroundColorAttributeName:[UIColor darkGrayColor]
            };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"忘记密码"
                                                                          attributes:normalAttributes];
        [_forgetPasswordButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        // 高亮标题
        NSDictionary *highlightedAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:15],
            NSForegroundColorAttributeName:[UIColor lightGrayColor]
            };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"忘记密码"
                                                                               attributes:highlightedAttributes];
        [_forgetPasswordButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        // Target-Action
        [_forgetPasswordButton addTarget:self
                                  action:@selector(buttonAction:)
                        forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgetPasswordButton;
}

// MARK: 发送短信验证码
- (UIButton *)sendCaptchaButton {
    if (!_sendCaptchaButton) {
        _sendCaptchaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // 默认标题
        NSDictionary *normalAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:15],
            NSForegroundColorAttributeName:[UIColor whiteColor]
            };
        NSAttributedString *normalTitle =[[NSAttributedString alloc] initWithString:@"获取验证码"
                                                                         attributes:normalAttributes];
        [_sendCaptchaButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        // 高亮标题
        UIColor *themeColor = HexColor(@"#47c1b6");
        NSDictionary *highLightedAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:15],
            NSForegroundColorAttributeName:themeColor
            };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"获取验证码"
                                                                               attributes:highLightedAttributes];
        [_sendCaptchaButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        // 设置背景颜色
        [_sendCaptchaButton setBackgroundImage:[UIImage jk_imageWithColor:themeColor]
                                      forState:UIControlStateNormal];
        [_sendCaptchaButton setBackgroundImage:[UIImage jk_imageWithColor:UIColor.whiteColor]
                                      forState:UIControlStateHighlighted];
        // 设置圆角
        _sendCaptchaButton.clipsToBounds = YES;
        _sendCaptchaButton.layer.cornerRadius = 5;
        // Target-Action
        [_sendCaptchaButton addTarget:self
                               action:@selector(buttonAction:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCaptchaButton;
}


// MARK: 提交按钮
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 设置按钮字体、颜色
        NSDictionary *normalAttributes = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17.0f],
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"提交" attributes:normalAttributes];
        [_submitButton setAttributedTitle:normalTitle forState:UIControlStateNormal];

        NSDictionary *highLightedAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:17.0f],
            NSForegroundColorAttributeName:HexColor(@"#47c1b6")
        };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"提交" attributes:highLightedAttributes];
        [_submitButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        
        // 按钮点击高亮效果，通过 UIColor 颜色设置背景图片
        [_submitButton setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#47c1b6")]
                                 forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#F5F5F9")]
                                 forState:UIControlStateHighlighted];
        
        // 设置按钮圆角
        _submitButton.layer.cornerRadius = 10.f;
        _submitButton.layer.masksToBounds = YES;
        
        [_submitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

// 单选按钮
- (UIButton *)radioButton {
    if (!_radioButton) {
        _radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_radioButton setTitle:@"全选" forState:UIControlStateNormal];
        [_radioButton setTitleColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1] forState:UIControlStateNormal];
        _radioButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_radioButton setImage:[UIImage imageNamed:@"button_unselect"] forState:UIControlStateNormal];
        [_radioButton setImage:[UIImage imageNamed:@"button_select"] forState:UIControlStateSelected];
//        [_radioButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_radioButton addTarget:self
                         action:@selector(radioButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        // ****** 隐藏全选按钮 ******
        // _radioButton.hidden = YES;
    }
    return _radioButton;
}

#pragma mark - Actions

- (void)buttonAction:(id)sender {
    [self.navigationController.view jk_makeToast:@"button Clicked."];
}

// MARK: 单选按钮
- (void)radioButtonAction:(id)sender {
    self.radioButton.selected = !self.radioButton.isSelected;
    
    if (self.radioButtonActionBlock) {
        self.radioButtonActionBlock(self.radioButton.isSelected);
    }
}

@end
