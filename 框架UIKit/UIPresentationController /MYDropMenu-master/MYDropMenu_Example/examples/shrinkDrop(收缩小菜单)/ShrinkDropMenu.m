//
//  ShrinkDropMenu.m
//  MYDropMenu_Example
//
//  Created by 孟遥 on 2017/3/31.
//  Copyright © 2017年 孟遥. All rights reserved.
//

#import "ShrinkDropMenu.h"

@interface ShrinkDropMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation ShrinkDropMenu

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, 125) style:UITableViewStylePlain];
        _tableview.delegate  = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"shrinkCell"];
        _tableview.rowHeight = 25;
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shrinkCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:8 weight:1];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = @"测试选项";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil]; //菜单消失
    //callback 为MYPresentedController公开属性 , id类型 , 可回调任意内容
    if (self.callback) {
        self.callback(@(indexPath.row));
    }
}


@end
