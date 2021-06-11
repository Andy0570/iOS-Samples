//
//  HQLButtonTableViewController+NavigationBar.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/5/6.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLButtonTableViewController+NavigationBar.h"
#import <ChameleonFramework/Chameleon.h>
#import <Toast/Toast.h>

@implementation HQLButtonTableViewController (NavigationBar)

- (void)hql_setupNavigationBar {
    // 自定义搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 190, 32);
    searchButton.layer.cornerRadius = 16;
    searchButton.layer.masksToBounds = YES;
    searchButton.backgroundColor = HexColor(@"#F5F5F9");
    // 标题
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    // 图片，18*18
    [searchButton setImage:[UIImage imageNamed:@"navBar_search"] forState:UIControlStateNormal];
    searchButton.adjustsImageWhenHighlighted = NO;
    // 设置图片、标题左对齐
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 图片向右移动 10pt
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10.0f, 0, 0);
    // 标题向右移动 20pt
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15.0f, 0, 0);
    [searchButton addTarget:self action:@selector(navigationSearchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;
}

- (void)navigationSearchButtonAction:(id)sender {
    [self.view makeToast:@"点击导航栏搜索"];
}

@end
