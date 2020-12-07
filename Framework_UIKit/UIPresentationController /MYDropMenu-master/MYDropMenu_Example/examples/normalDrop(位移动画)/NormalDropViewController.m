//
//  NormalDropViewController.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "NormalDropViewController.h"
#import "NormalDropMenu.h"
#import "HQLPasswordViewController.h"

@interface NormalDropViewController ()

@end

@implementation NormalDropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"常规下拉菜单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 200, 21);
    [button addTarget:self action:@selector(normalFromTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"常规上拉拉菜单" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(100, 150, 200, 21);
    [button1 addTarget:self action:@selector(normalFromBottomMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"弹出密码输入框" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button2.frame = CGRectMake(100, 200, 200, 21);
    [button2 addTarget:self action:@selector(passwordView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}


#pragma mark - 常规位移动画,从下往上 . 上拉菜单
- (void)normalFromBottomMenu
{
    NormalDropMenu *menu = [[NormalDropMenu alloc] initWithShowFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 320, [UIScreen mainScreen].bounds.size.width, 320) ShowStyle:MYPresentedViewShowStyleFromBottomDropStyle callback:^(id callback) {
        
        NSLog(@"-----------------------操作了--%@",callback);
    }];
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark - 常规位移动画,从上往下 , 下拉菜单
- (void)normalFromTopMenu
{
    NormalDropMenu *menu = [[NormalDropMenu alloc] initWithShowFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 320) ShowStyle:MYPresentedViewShowStyleFromTopDropStyle callback:^(id callback) {
        
        NSLog(@"---------------操作了-----%@",callback);
    }];
    [self presentViewController:menu animated:YES completion:nil];
}

#pragma mark - 调试-弹出密码输入框
- (void)passwordView {
    
    // !!!: 该示例为之前的遗留代码（Deprecated），请联系开发者，获取更新版本的实现！
    HQLPasswordViewController *vc = [[HQLPasswordViewController alloc] initWithShowFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 412, [UIScreen mainScreen].bounds.size.width, 412) ShowStyle:MYPresentedViewShowStyleFromBottomDropStyle callback:^(id callback) {
        
    }];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}

@end
