//
//  ButtonTemplate01ViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/12/3.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "ButtonTemplate01ViewController.h"

// 第三方框架
#import <Chameleon.h>
#import <JKCategories.h>
#import <Masonry/Masonry.h>

@interface ButtonTemplate01ViewController ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation ButtonTemplate01ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.button];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // 页面底部按钮
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(24);
        make.right.equalTo(self.view).with.offset(-24);
        make.height.mas_equalTo(52);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-15);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view).with.offset(-15);
        }
    }];
}

#pragma mark - Custom Accessors

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置圆角按钮
        _button.layer.cornerRadius = 5.f;
        _button.layer.masksToBounds = YES;
        // 标题
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:18], // 默认字体：#18
            NSForegroundColorAttributeName:[UIColor whiteColor]
        };
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"按钮标题" attributes:attributes];
        [_button setAttributedTitle:title forState:UIControlStateNormal];
        
        // 背景颜色
        [_button setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#108EE9")]
                           forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage jk_imageWithColor:HexColor(@"#1284D6")]
                           forState:UIControlStateHighlighted];
        
        [_button addTarget:self
                    action:@selector(buttionDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark - Actions

- (void)buttionDidClicked:(id)sender {
    [self.navigationController.view jk_makeToast:@"Button clicked."];
}

@end
