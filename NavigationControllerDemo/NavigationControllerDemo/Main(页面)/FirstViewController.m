//
//  FirstViewController.m
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面背景颜色
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 💡 设置导航标题栏属性
    [self setNavigationItemAttributes];
    
    
    /**
     设置导航栏返回按钮
     
     注意点：
     * 下一个页面的导航栏返回按钮样式，需要在上一个页面设置，也就是说，我在首页设置的导航栏返回按钮，下一个页面起作用。
     * 但是如果你在下一个页面又自己实现了自定义样式的 leftBarButtonItem，则这里的设置就会被覆盖！
     */
    [self addNavigationLeftBarbutton];
    
    // 💡 添加导航栏右侧按钮
    [self addNavigationRightBarbutton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}


#pragma mark - IBActions

// 导航栏按钮点击事件方法
- (void)rightBarButtonItemDidClicked:(id)sender {
    // 初始化第二个视图控制器对象
    SecondViewController *vc = [[SecondViewController alloc] init];
    // 将第二个视图控制器对象压入导航视图控制器中，实现页面的跳转
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private

- (void)setNavigationItemAttributes {
    // 设置当前视图的导航栏标题
    self.navigationItem.title = @"首页";
    // 设置顶部导航区的提示文字，prompt 属性表示在导航栏按钮上方显示的说明文字
    // self.navigationItem.prompt = @"Loading";
    // 设置导航栏背景是否透明
    self.navigationController.navigationBar.translucent = NO;
    // 设置导航栏系统样式
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // 设置导航按钮文本颜色，默认蓝色
    // ⚠️ 此属性设置的是全局导航栏颜色
    // self.navigationController.navigationBar.tintColor = [UIColor greenColor];
    
    // 💡 删除导航栏底部线条
    // [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)addNavigationLeftBarbutton {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:nil];
    self.navigationItem.backBarButtonItem = leftItem;
}

- (void)addNavigationRightBarbutton {
    // 设置当前视图右上角的导航栏按钮标题，以及按钮点击事件
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"按钮"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(rightBarButtonItemDidClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

@end
