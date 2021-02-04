//
//  SecondViewController.m
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation SecondViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面背景颜色
    self.view.backgroundColor = [UIColor whiteColor];

    // 添加按钮
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.nextButton];
    
    
    // 💡 自定义导航栏：左侧按钮、右侧按钮、中间标题；
    [self customizeNavigationBar];
}


#pragma mark - Custom Accessors

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(20, 200, 100, 60);
        // 默认标题
        [_backButton setTitle:@"上一页" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor colorWithRed:0 green:166/255.0 blue:224/255.0 alpha:1]
                          forState:UIControlStateNormal];
        // 设置圆角
        _backButton.clipsToBounds = YES;
        _backButton.layer.cornerRadius = 5;
        [_backButton addTarget:self
                         action:@selector(backButtonDidClicked:)
               forControlEvents:UIControlEventTouchUpInside];

    }
    return _backButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(150, 200, 100, 60);
        // 默认标题
        [_nextButton setTitle:@"下一页" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor colorWithRed:255/255.0 green:63/255.0 blue:71/255.0 alpha:1]
                          forState:UIControlStateNormal];
        // 设置圆角
        _nextButton.clipsToBounds = YES;
        _nextButton.layer.cornerRadius = 5;
        [_nextButton addTarget:self
                         action:@selector(nextButtonDidClicked:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}


#pragma mark - IBActions

// 💡 点击返回按钮，返回到上一个页面
- (void)backButtonDidClicked:(id)sender {
    // 当前视图控制器将从导航视图控制器堆栈中移除，并返回至上一视图，相当于出栈操作
    [self.navigationController popViewControllerAnimated:YES];
}

// 💡 点击下一页按钮，推入下一个页面
- (void)nextButtonDidClicked:(id)sender {
    ThirdViewController *vc = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftButtonDidClicked:(id)sender {
    NSLog(@"Left Bar Button Did Clicked!");
}

- (void)rightButtonDidClicked:(id)sender {
    NSLog(@"Right Bar Button Did Clicked!");
}


#pragma mark - Private

- (void)customizeNavigationBar {
    // --------------------------------------------
    // 实例化一个工具条按钮对象，它将作为我们新的导航按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(leftButtonDidClicked:)];
    // 将导航栏左侧按钮，设置为新的工具条按钮对象
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // --------------------------------------------
    // 同样为导航栏右侧的导航按钮，设置新的样式
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                        target:self
                                                        action:@selector(rightButtonDidClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // --------------------------------------------
    // 创建一个视图对象，它将作为我们导航栏的标题区
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [titleView setBackgroundColor:[UIColor brownColor]];
    // 新建一个标签对象，它将显示标题区的标题文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.text = @"我是自定义标题";
    [titleView addSubview:label];
    // 将视图对象设置为导航栏的标题区
    self.navigationItem.titleView = titleView;
}

@end
