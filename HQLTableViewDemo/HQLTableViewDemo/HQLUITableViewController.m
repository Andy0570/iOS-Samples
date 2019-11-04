//
//  HQLUITableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/5/11.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "HQLUITableViewController.h"

#import "MainTableViewController.h"
#import "SecnodTableViewController.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@interface HQLUITableViewController ()

@property (nonatomic, copy) NSArray *dataSourceArray;

@end

@implementation HQLUITableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReusreIdentifier];
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"UITableViewStyleGrouped",
                             @"UITableViewStylePlain"];
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

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"MVC实现的两种静态列表样式";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MainTableViewController *mainTVC = [[MainTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:mainTVC animated:YES];
    }
    if (indexPath.row == 1) {
        SecnodTableViewController *secondTVC = [[SecnodTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:secondTVC animated:YES];
    }
    
}

@end
