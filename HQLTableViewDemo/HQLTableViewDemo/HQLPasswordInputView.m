//
//  HQLPasswordInputView.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/3/6.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLPasswordInputView.h"

static const int numberOfBox = 6;   // 输入密码的位数
static const CGFloat widthOfBox = 40.0; // 输入方格的边长

@interface HQLPasswordInputView()

@property (nonatomic,strong) NSMutableArray *boxesArray;
@property (nonatomic,weak) UITextField *contentTextField;

@end

@implementation HQLPasswordInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView {
    UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.contentTextField = contentField;
    contentField.placeholder = @"请输入支付密码";
    contentField.hidden = YES;
    [contentField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:contentField];
    
    // 密码之间的间隔
    CGFloat margin = 10;
    for (int i = 0; i < numberOfBox; i++) {
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - numberOfBox * widthOfBox - (numberOfBox - 1) * margin) * 0.5 + (widthOfBox + margin) * i;
        UITextField *pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake(x, (self.frame.size.height - widthOfBox) * 0.5, widthOfBox, widthOfBox)];
        pwdLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        pwdLabel.layer.borderWidth = 1;
        pwdLabel.enabled = NO;
        pwdLabel.textAlignment = NSTextAlignmentCenter;
        pwdLabel.secureTextEntry = YES;
        [self addSubview:pwdLabel];
        
        [self.boxesArray addObject:pwdLabel];
    }
    //进入界面，contentTextField 成为第一响应者
    [self.contentTextField becomeFirstResponder];
}

- (NSMutableArray *)boxesArray {
    if (!_boxesArray) {
        _boxesArray = [NSMutableArray array];
    }
    return _boxesArray;
}

#pragma mark 文本框内容改变
- (void)textChange:(UITextField *)textField {
    NSString *password = textField.text;
    for (int i = 0; i < self.boxesArray.count; i ++) {
        UITextField *passwordTextField = [self.boxesArray objectAtIndex:i];
        passwordTextField.text = @"";
        if (i<password.length) {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            passwordTextField.text = pwd;
        }
    }
    // 输入密码完毕
    if (password.length == numberOfBox) {
        [textField resignFirstResponder];
        if (self.returnPasswordStringBlock) {
            self.returnPasswordStringBlock(password);
        }
    }
}

@end
