//
//  HQListHegihtAdaptiveTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/5/11.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "HQListHegihtAdaptiveTableViewController.h"

#import "HQLAutoHeightTableViewController.h"
#import "HQLAutoHeight2TableViewController.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@interface HQListHegihtAdaptiveTableViewController ()

@property (nonatomic, copy) NSArray *dataSourceArray;

@end

@implementation HQListHegihtAdaptiveTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReusreIdentifier];
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"方法一",@"方法二"];
    }
    return _dataSourceArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier
                                                            forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HQLAutoHeightTableViewController *autoHeightTVC = [[HQLAutoHeightTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:autoHeightTVC animated:YES];
    } else if (indexPath.row == 1) {
        HQLAutoHeight2TableViewController *autoHeight2TVC = [[HQLAutoHeight2TableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:autoHeight2TVC animated:YES];
    }
}

@end
