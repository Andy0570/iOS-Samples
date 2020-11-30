//
//  ButtonBasicUsageViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "ButtonBasicUsageViewController.h"
#import <Masonry.h>
#import <Chameleon.h>
#import <JKCategories.h>

@interface ButtonBasicUsageViewController ()
@property (nonatomic, strong) UIButton *showPasswordButton;
@end

@implementation ButtonBasicUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self addButtonType1];
    [self addButtonType2];
    [self addButtonWithBorder];
}

// 按钮高亮效果
- (void)addButtonType1 {
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // 默认标题
    NSDictionary *attributes = @{
                         NSFontAttributeName:[UIFont systemFontOfSize:18],
              NSForegroundColorAttributeName:[UIColor whiteColor] };
    NSAttributedString *title =[[NSAttributedString alloc] initWithString:@"提交" attributes:attributes];
    [submitButton setAttributedTitle:title forState:UIControlStateNormal];
    // 设置背景颜色
    // 使用 YYKit 组件实现将颜色生成图片效果
    
    [submitButton setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#108EE9")]
                             forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#1284D6")]
                             forState:UIControlStateHighlighted];
    // 设置圆角
    submitButton.clipsToBounds = YES;
    submitButton.layer.cornerRadius = 5;
    [submitButton addTarget:self
                     action:@selector(buttonClickUpHandler:)
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

- (void)addButtonType2 {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 默认标题
    NSDictionary *attributes1 = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:13],
               NSForegroundColorAttributeName:HexColor(@"#108EE9")
                                 };
    NSAttributedString *normalTitle =[[NSAttributedString alloc] initWithString:@"示例" attributes:attributes1];
    [button setAttributedTitle:normalTitle
                      forState:UIControlStateNormal];
    // 高亮标题
    NSDictionary *attributes2 = @{
                         NSFontAttributeName:[UIFont systemFontOfSize:13],
              NSForegroundColorAttributeName:[UIColor whiteColor]
                                 };
    NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"示例" attributes:attributes2];
    [button setAttributedTitle:highlightedTitle
                           forState:UIControlStateHighlighted];
    // 高亮背景颜色
    [button setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#108EE9")]
                           forState:UIControlStateHighlighted];
    [button.layer setCornerRadius:3];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1];
    [button.layer setBorderColor:[HexColor(@"#108EE9") CGColor]];
    // Target-Action
    [button addTarget:self
               action:@selector(buttonClickUpHandler:)
     forControlEvents:UIControlEventTouchUpInside];
    
    // 将按钮添加到视图上
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(80);
        make.left.mas_equalTo(self.view.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
}

// 设置边框
- (void)addButtonWithBorder {
    // 创建一个按钮
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    button3.frame = CGRectMake(80, 450, 150, 30);
    // 设置按钮的背景色
    button3.backgroundColor = [UIColor flatLimeColorDark];
    // 设置按钮的前景色
    button3.tintColor = [UIColor flatLimeColor];
    // 设置按钮的标签文字
    [button3 setTitle:@"Tap it" forState:UIControlStateNormal];
    // 给按钮添加边框效果
    [button3.layer setMasksToBounds:YES];
    // 设置层的圆角半径
    [button3.layer setCornerRadius:5.0];
    // 设置边框的宽度
    [button3.layer setBorderWidth:2.0];
    // 设置边框的颜色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorRef = CGColorCreate(colorSpace, (CGFloat[]){ 56/255.0, 237/255.0, 56/255.0, 1 });
    [button3.layer setBorderColor:colorRef];
    [self.view addSubview:button3];
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
                                action:@selector(showPasswordButtonDidClicked:)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}

#pragma mark - Actions

- (void)buttonClickUpHandler:(id)sender {
    [self.navigationController.view jk_makeToast:@"submit Button."];
}

- (void)showPasswordButtonDidClicked:(id)sender {
    // self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    // [self.showPasswordButton setSelected:!self.passwordTextField.secureTextEntry];
}

@end
