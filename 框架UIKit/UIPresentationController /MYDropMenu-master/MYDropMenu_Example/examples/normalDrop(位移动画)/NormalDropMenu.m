//
//  NormalDropMenu.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "NormalDropMenu.h"

@interface NormalDropMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *handleNames;
@end

@implementation NormalDropMenu


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    //布局你需要的UI样式
    [self.view addSubview:self.tableView];
}


#pragma mark - Custom Accessors

- (UITableView *)tableView
{
    if (!_tableView) {
        //设置tableView大小为菜单一样大小
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 320) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.bounces = NO; // 是否有弹簧动画
    }
    return _tableView;
}

- (NSArray *)handleNames
{
    if (!_handleNames) {
        _handleNames = @[@"操作一",@"操作二",@"操作三",@"操作四"];
    }
    return _handleNames;
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:18.f weight:1.f];
    cell.textLabel.textColor = [UIColor greenColor];
    cell.textLabel.text = self.handleNames[indexPath.row];
    return cell;
}


#pragma mark - 回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            if (self.callback) {
                self.callback(self.handleNames[indexPath.row]);
            }
            [self dismissViewControllerAnimated:YES completion:nil]; //菜单消失
        }
            break;
        case 1:
        {
            if (self.callback) {
                self.callback(self.handleNames[indexPath.row]);
            }
            [self dismissViewControllerAnimated:YES completion:nil]; //菜单消失
        }
            break;
        case 2:
        {
            if (self.callback) {
                self.callback(self.handleNames[indexPath.row]);
            }
            [self dismissViewControllerAnimated:YES completion:nil]; //菜单消失
        }
            break;
        case 3:
        {
            if (self.callback) {
                self.callback(self.handleNames[indexPath.row]);
            }
            [self dismissViewControllerAnimated:YES completion:nil]; //菜单消失
        }
            break;
        default:
            break;
    }
}



@end
