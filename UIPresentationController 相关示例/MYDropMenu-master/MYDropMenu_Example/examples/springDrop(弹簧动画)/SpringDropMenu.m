//
//  SpringDropMenu.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SpringDropMenu.h"

@interface SpringDropMenu ()

@end

@implementation SpringDropMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 150)];
    label.numberOfLines = 0;
    label.text = @"在这里布局你需要的控件,并可以通过实现callback将操作信息回调出去";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.f weight:1.f];
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 100);
    [self.view addSubview:button];
}

- (void)makeSure
{
    
    //回调操作
    if (self.callback) {
        self.callback(@"点击了确定");
    }
    [self dismissViewControllerAnimated:YES completion:nil]; //菜单消失
}


@end
