//
//  SpreadDropViewController.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SpreadDropViewController.h"
#import "SpreadDropMenu.h"

@interface SpreadDropViewController ()

@end

@implementation SpreadDropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"从上往下展开菜单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 200, 80);
    [button addTarget:self action:@selector(normalFromTopMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"从下往上展开菜单" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(100, 200, 200, 80);
    [button1 addTarget:self action:@selector(normalFromBottomMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:button1];
}

#pragma mark - 展开动画,从下往上 . 上拉菜单
- (void)normalFromBottomMenu
{
    
    //创建菜单
    SpreadDropMenu *menu = [[SpreadDropMenu alloc]initWithShowFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromBottomSpreadStyle callback:^(id callback) {
        
        //在此处获取菜单对应的操作 ， 而做出一些处理
        NSLog(@"-----------------%@",callback);
    }];
    
    //菜单展示
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark - 展开动画,从上往下 , 下拉菜单
- (void)normalFromTopMenu
{
    
    //创建菜单
    SpreadDropMenu *menu = [[SpreadDropMenu alloc]initWithShowFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle callback:^(id callback) {
        
        //在此处获取菜单对应的操作 ， 而做出一些处理
        NSLog(@"-----------------%@",callback);
    }];
    
    //菜单展示
    [self presentViewController:menu animated:YES completion:nil];
}

@end
