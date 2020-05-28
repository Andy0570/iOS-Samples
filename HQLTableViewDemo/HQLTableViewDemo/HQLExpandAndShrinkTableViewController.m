//
//  HQLExpandAndShrinkTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/28.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLExpandAndShrinkTableViewController.h"

// Controllers
#import "HQLFirstTableViewController.h"
#import "HQLSecongTableViewController.h"
#import "HQLDepartmentViewController.h"
#import "UITwoTableViewController.h"
#import "HQLBrandListViewController.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyle";

@interface HQLExpandAndShrinkTableViewController ()

/** 列表数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HQLExpandAndShrinkTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"展开收缩列表";
    [self setupTableView];
}

- (void)setupTableView {
    // 注册TableViewCell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReusreIdentifier];
    // 隐藏页脚视图分割线
//    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Accessors

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithObjects:
                       @"QQ分组样式一",
                       @"QQ分组样式二",
                       @"左右联动样式：医院科室",
                       @"左右联动样式",
                       @"左右联动样式：品牌列表",
                       nil];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
    // 设置辅助指示箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 方法一列表
        HQLFirstTableViewController *firstTableViewCell = [[HQLFirstTableViewController alloc] init];
        [self.navigationController pushViewController:firstTableViewCell animated:YES];
    }
    if (indexPath.row == 1) {
        // 方法二列表
        HQLSecongTableViewController *secondTableViewController = [[HQLSecongTableViewController alloc] init];
        [self.navigationController pushViewController:secondTableViewController animated:YES];
    }
    if (indexPath.row == 2) {
        // 方式三列表
        HQLDepartmentViewController *vc = [[HQLDepartmentViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
        // 方式四列表，左右TableView的联动
        UITwoTableViewController *twoTVC = [[UITwoTableViewController alloc] init];
        [self.navigationController pushViewController:twoTVC animated:YES];
    }
    if (indexPath.row == 4) {
        // 左右联动样式：品牌列表
        HQLBrandListViewController *brandVC = [[HQLBrandListViewController alloc] init];
        [self.navigationController pushViewController:brandVC animated:YES];
    }
}

@end
