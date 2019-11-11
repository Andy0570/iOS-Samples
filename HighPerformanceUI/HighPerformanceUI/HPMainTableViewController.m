//
//  HPMainTableViewController.m
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/5.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HPMainTableViewController.h"

// Controller
#import "HPMailCompositeTableViewController.h"
#import "HPMailCompositeHandTableViewController.h"
#import "HPMailDirectDrawTableViewController.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@implementation HPMainTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    [self setupTableView];
}

#pragma mark - Private

- (void)setupTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReusreIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"复合视图（NIB方式）";
            break;
        }
        case 1: {
            cell.textLabel.text = @"复合视图（手写代码）";
            break;
        }
        case 2: {
            cell.textLabel.text = @"直接绘制";
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 复合视图，NIB方式
    if (indexPath.row == 0) {
        HPMailCompositeTableViewController *tvc = [[HPMailCompositeTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:tvc animated:YES];
    }
    
    // 手写代码
    if (indexPath.row == 1) {
        HPMailCompositeHandTableViewController *hvc = [[HPMailCompositeHandTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:hvc animated:YES];
    }
    
    // 直接绘制
    if (indexPath.row == 2) {
        HPMailDirectDrawTableViewController *dtvc = [[HPMailDirectDrawTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:dtvc animated:YES];
    }
}

@end
