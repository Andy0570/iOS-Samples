//
//  SpringDropViewController.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SpringDropViewController.h"
#import "SpringDropMenu.h"

@interface SpringDropViewController ()

@end

@implementation SpringDropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"顶部弹簧菜单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 200, 80);
    [button addTarget:self action:@selector(springFromTopMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"底部弹簧菜单" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(100, 200, 200, 80);
    [button1 addTarget:self action:@selector(springFromBottomMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"顶部出现,中间弹簧菜单" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button2.frame = CGRectMake(100, 300, 200, 80);
    [button2 addTarget:self action:@selector(springFromTopToMidMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"顶部出现,中间弹簧菜单" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button3.frame = CGRectMake(100, 400, 200, 80);
    [button3 addTarget:self action:@selector(springFromBottomToMidMenu) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
}


#pragma mark - 普通弹簧动画,从上往下 . 下拉菜单
- (void)springFromTopMenu
{
    SpringDropMenu *menu = [[SpringDropMenu alloc]initWithShowFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromTopSpringStyle callback:nil];
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark - 普通弹簧动画,从下往上 , 上拉菜单
- (void)springFromBottomMenu
{
    SpringDropMenu *menu = [[SpringDropMenu alloc]initWithShowFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromBottomSpringStyle callback:nil];
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark - 弹簧动画 , 顶部开始,中间展示
- (void)springFromTopToMidMenu
{
    SpringDropMenu *menu = [[SpringDropMenu alloc]initWithShowFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)*0.5, ([UIScreen mainScreen].bounds.size.height - 300)*0.5, 300, 300) ShowStyle:MYPresentedViewShowStyleFromTopSpringStyle callback:nil];
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark - 弹簧动画,底部开始,中间展示
- (void)springFromBottomToMidMenu
{
    SpringDropMenu *menu = [[SpringDropMenu alloc]initWithShowFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)*0.5, ([UIScreen mainScreen].bounds.size.height - 300)*0.5, 300, 300) ShowStyle:MYPresentedViewShowStyleFromBottomSpringStyle callback:nil];
    [self presentViewController:menu animated:YES completion:nil];
}

@end
