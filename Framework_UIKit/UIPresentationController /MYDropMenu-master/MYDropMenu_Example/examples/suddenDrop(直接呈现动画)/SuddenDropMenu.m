//
//  SuddenDropMenu.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SuddenDropMenu.h"

@interface SuddenDropMenu ()

@end

@implementation SuddenDropMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"在这里布局你需要的空间，并可以通过callback将操作回调";
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    [self.view addSubview:label];
}


@end
