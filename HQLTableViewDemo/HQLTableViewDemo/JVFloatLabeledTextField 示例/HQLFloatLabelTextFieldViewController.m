//
//  HQLFloatLabelTextFieldViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/12/2.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLFloatLabelTextFieldViewController.h"
#import <JVFloatLabeledTextField.h>
#import <Chameleon.h>
#import <Masonry.h>

@interface HQLFloatLabelTextFieldViewController () <UITextFieldDelegate>
@property (nonatomic, strong) JVFloatLabeledTextField *idNumberTextField;
@end

@implementation HQLFloatLabelTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor flatWhiteColor];
    [self.view addSubview:self.idNumberTextField];
    
    [self addGestureRecognizer];
}

// 添加单击手势，点击屏幕空白部分，收起键盘
- (void)addGestureRecognizer {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.idNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(40);
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
        make.height.mas_equalTo(55);
    }];
}

#pragma mark - Custom Accessors

- (JVFloatLabeledTextField *)idNumberTextField {
    if (!_idNumberTextField) {
        _idNumberTextField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
        _idNumberTextField.font = [UIFont systemFontOfSize:18.0f];
        // 浮动式标签的正常字体颜色
        _idNumberTextField.floatingLabelTextColor = UIColor.systemBlueColor;
        // 输入框成为第一响应者时,浮动标签的文字颜色.
        _idNumberTextField.floatingLabelActiveTextColor = UIColor.systemBlueColor;
        // 指明当输入文字时,是否下调基准线(baseline).设置为YES(非默认值),意味着占位内容会和输入内容对齐.
        _idNumberTextField.keepBaseline = YES;
        // 设置占位符文字和浮动式标签的文字.
        [_idNumberTextField setPlaceholder:@"请输入身份证号码" floatingTitle:@"身份证号码"];
        _idNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _idNumberTextField.delegate = self;
    }
    return _idNumberTextField;
}

#pragma mark - UITextFieldDelegate

@end
