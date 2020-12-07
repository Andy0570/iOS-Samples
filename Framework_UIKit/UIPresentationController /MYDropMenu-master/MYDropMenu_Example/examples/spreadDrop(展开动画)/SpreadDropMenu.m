//
//  SpreadDropMenu.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SpreadDropMenu.h"

@interface SpreadDropMenu ()
@end

@implementation SpreadDropMenu


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor greenColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"在这里布局你需要展示的菜单空间，并可以通过实现callback将操作回调出去";
    label.numberOfLines = 0;
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,100);
    [self.view addSubview:label];
    
    
    UIButton *handleButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [handleButton1 setTitle:@"确定" forState:UIControlStateNormal];
    [handleButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handleButton1 addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    handleButton1.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 60);
    [self.view addSubview:handleButton1];
    
    UIButton *handleButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [handleButton2 setTitle:@"取消" forState:UIControlStateNormal];
    [handleButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handleButton2 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    handleButton2.frame = CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, 60);
    [self.view addSubview:handleButton2];
}





- (void)makeSure
{
    if (self.callback) {
        self.callback(@"点击了确定");
    }
    [self dismissViewControllerAnimated:YES completion:nil];   //菜单消失
}


- (void)cancel
{
    if (self.callback) {
        self.callback(@"点击了取消");
    }
    [self dismissViewControllerAnimated:YES completion:nil];   //菜单消失
}




@end
