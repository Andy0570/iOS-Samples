//
//  ViewController.m
//  MYDropMenu
//
//  Created by 孟遥 on 2017/2/24.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import "ViewController.h"

#import "NormalDropViewController.h"
#import "SpreadDropViewController.h"
#import "SpringDropViewController.h"
#import "SuddenDropViewController.h"
#import "ShrinkDropController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *styleNames;
@end

@implementation ViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

- (NSArray *)styleNames
{
    if (!_styleNames) {
        _styleNames = @[@"位移动画上拉下拉使用",
                        @"展开动画上下下拉使用",
                        @"弹簧动画上拉下拉使用",
                        @"直接呈现菜单使用",
                        @"收缩小菜单使用"];
    }
    return _styleNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"效果列表";
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.styleNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:18.f weight:1.f];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = self.styleNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            NormalDropViewController *normalDropVc = [[NormalDropViewController alloc] init];
            [self.navigationController pushViewController:normalDropVc animated:YES];
        }
            break;
        case 1:
        {
            SpreadDropViewController *normalDropVc = [[SpreadDropViewController alloc] init];
            [self.navigationController pushViewController:normalDropVc animated:YES];
        }
            break;
        case 2:
        {
            SpringDropViewController *normalDropVc = [[SpringDropViewController alloc] init];
            [self.navigationController pushViewController:normalDropVc animated:YES];
        }
            break;
        case 3:
        {
            SuddenDropViewController *normalDropVc = [[SuddenDropViewController alloc] init];
            [self.navigationController pushViewController:normalDropVc animated:YES];
        }
            break;
        case 4:
        {
            ShrinkDropController *shrinkDropVc = [[ShrinkDropController alloc] init];
            [self.navigationController pushViewController:shrinkDropVc animated:YES];
            break;
        }
        default:
            break;
    }
}




@end



