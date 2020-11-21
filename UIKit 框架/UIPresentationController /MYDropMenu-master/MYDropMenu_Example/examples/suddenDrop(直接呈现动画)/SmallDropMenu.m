//
//  SmallDropMenu.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "SmallDropMenu.h"

@interface SmallDropMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) NSArray *handles;
@end

@implementation SmallDropMenu

- (NSArray *)handles
{
    if (!_handles) {
        _handles = @[@"第一个操作",@"第二个操作",@"第三个操作",@"第四个操作"];
    }
    return _handles;
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 200) style:UITableViewStylePlain];
        [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.rowHeight = 50;
    }
    return _listTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:self.listTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:10.f weight:1.f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = self.handles[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //回调操作
    if (self.callback) {
        self.callback(self.handles[indexPath.row]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];  //菜单消失
}




@end
