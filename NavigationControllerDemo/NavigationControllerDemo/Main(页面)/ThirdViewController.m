//
//  ThirdViewController.m
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *backToRootButton;

@end

@implementation ThirdViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加按钮
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.backToRootButton];
}

// 每当进入此页面时，隐藏页面顶部的导航栏和页面底部的工具栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 隐藏当前视图控制器的顶部导航栏
    [self.navigationController setNavigationBarHidden:YES];
    // 隐藏底部工具栏
    [self.navigationController setToolbarHidden:YES];
}

// 每当退出此页面时，不再隐藏页面顶部的导航栏和页面底部的工具栏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}


#pragma mark - Custom Accessors

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(20, 200, 100, 60);
        // 默认标题
        [_backButton setTitle:@"上一页" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor colorWithRed:0 green:166/255.0 blue:224/255.0 alpha:1] forState:UIControlStateNormal];
        // 设置圆角
        _backButton.clipsToBounds = YES;
        _backButton.layer.cornerRadius = 5;
        [_backButton addTarget:self
                         action:@selector(backButtonDidClicked:)
               forControlEvents:UIControlEventTouchUpInside];

    }
    return _backButton;
}

- (UIButton *)backToRootButton {
    if (!_backToRootButton) {
        _backToRootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backToRootButton.frame = CGRectMake(150, 200, 100, 60);
        // 默认标题
        [_backToRootButton setTitle:@"返回首页" forState:UIControlStateNormal];
        [_backToRootButton setTitleColor:[UIColor colorWithRed:255/255.0 green:63/255.0 blue:71/255.0 alpha:1] forState:UIControlStateNormal];
        // 设置圆角
        _backToRootButton.clipsToBounds = YES;
        _backToRootButton.layer.cornerRadius = 5;
        [_backToRootButton addTarget:self
                         action:@selector(backToRootButtonDidClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToRootButton;
}


#pragma mark - IBActions

// 点击返回按钮，返回到上一个页面
- (void)backButtonDidClicked:(id)sender {
    // 当前视图控制器将从导航视图控制器堆栈中移除，并返回至上一视图，相当于出栈操作
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击返回首页按钮，直接返回到根视图控制器页面
- (void)backToRootButtonDidClicked:(id)sender {
    // 导航视图控制器中的所有子视图控制器，都将全部出栈，从而跳转到根视图控制器。
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
