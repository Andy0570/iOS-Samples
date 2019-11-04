//
//  HQLContactsSearchTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/5/10.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "HQLContactsSearchTableViewController.h"
#import "HQLContactsTableViewController.h"
#import "HQLContactWay2TableViewController.h"
#import "HQLSearchTableViewController.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@interface HQLContactsSearchTableViewController ()
@property (nonatomic, copy) NSArray *dataSourceArray;
@end

@implementation HQLContactsSearchTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"通讯录搜索Demo";
    [self setupTableView];
}

- (void)setupTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReusreIdentifier];
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"通讯录搜索1",
                             @"通讯录搜索2",
                             @"搜索示例"];
    }
    return _dataSourceArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 通讯录搜索1
        HQLContactsTableViewController *contactsTVC = [[HQLContactsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:contactsTVC animated:YES];
    }
    if (indexPath.row == 1) {
        // 通讯录搜索2
        HQLContactWay2TableViewController *way2TVC = [[HQLContactWay2TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:way2TVC animated:YES];
    }
    if (indexPath.row == 2) {
        // UISearchController
        HQLSearchTableViewController *searchVC = [[HQLSearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

@end
