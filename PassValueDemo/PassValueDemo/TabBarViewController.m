//
//  TabBarViewController.m
//  PassValueDemo
//
//  Created by ToninTech on 2017/3/15.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 首页
    UITabBarItem *item1 = self.tabBar.items[0];
    item1.title = @"首页";
    item1.image = [UIImage imageNamed:@"3"];
    // 登录页
    UITabBarItem *item2 = self.tabBar.items[1];
    item2.title = @"登录";
    item2.image = [UIImage imageNamed:@"4"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
