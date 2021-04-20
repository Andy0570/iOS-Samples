//
//  HQLSelectTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/4/1.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLSelectTableViewController.h"
#import "HQLSelectTableViewCell.h"

static NSString * const cellReuseIdentifier = @"HQLSelectTableViewCell";

@interface HQLSelectTableViewController ()

@end

@implementation HQLSelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 44.0f;
    [self.tableView registerClass:[HQLSelectTableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    cell.title = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

@end
