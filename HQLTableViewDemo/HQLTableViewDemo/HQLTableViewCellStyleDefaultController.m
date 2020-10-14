//
//  HQLTableViewCellStyleDefaultController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTableViewCellStyleDefaultController.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLTableViewCellStyleDefaultController ()

@end

@implementation HQLTableViewCellStyleDefaultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Default 样式";
    
    [self setupTableView];
}

- (void)setupTableView {
    // 注册重用 cell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    // 通过模型渲染 cell
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.imageView.image = [UIImage imageNamed:@"dribbble"];
    cell.textLabel.text = @"标题文本";
    cell.detailTextLabel.text = @"详细数据文本";
    // cell 右侧的箭头指示器
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
