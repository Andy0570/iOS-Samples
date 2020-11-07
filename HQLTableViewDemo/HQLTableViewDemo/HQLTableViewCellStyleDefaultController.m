//
//  HQLTableViewCellStyleDefaultController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTableViewCellStyleDefaultController.h"

// Framework
#import <Masonry.h>

// View
#import "HQLTableHeaderView.h"

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
    
    /**
     添加一个使用自动布局约束的 tableHeaderView
     
     当 tableHeaderView 的高度通过动态方式布局时，如何设置？
     这里的解决方案：通过系统方法（systemLayoutSizeFittingSize）计算高度再返回
     */
    HQLTableHeaderView *headerView = [[HQLTableHeaderView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = headerView;
    
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    CGRect headerViewFrame = headerView.frame;
    headerViewFrame.size.height = height;
    headerView.frame = headerViewFrame;
    [self.tableView.tableHeaderView layoutIfNeeded];
    
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
