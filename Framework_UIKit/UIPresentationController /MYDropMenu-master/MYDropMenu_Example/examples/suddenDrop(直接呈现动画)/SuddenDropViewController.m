//
//  SuddenDropViewController.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SuddenDropViewController.h"
#import "SmallDropMenu.h"
#import "SuddenDropMenu.h"

@interface SuddenDropViewController ()

@end

@implementation SuddenDropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"直接呈现效果" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 200, 80);
    [button addTarget:self action:@selector(suddenShowMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"小菜单使用效果" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(100, 200, 200, 80);
    [button1 addTarget:self action:@selector(smallMenuExample) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];

}

#pragma mark - 普通弹簧动画,从上往下 . 下拉菜单
- (void)suddenShowMenu
{
    SuddenDropMenu *menu = [[SuddenDropMenu alloc]initWithShowFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 300) ShowStyle:MYPresentedViewShowStyleSuddenStyle callback:nil];
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark - 小菜单
- (void)smallMenuExample
{
    SmallDropMenu *smallMenu = [[SmallDropMenu alloc]initWithShowFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 130, 64, 100, 200) ShowStyle:MYPresentedViewShowStyleSuddenStyle callback:^(id callback) {
        
    }];
    [self presentViewController:smallMenu animated:YES completion:nil];
}

@end
