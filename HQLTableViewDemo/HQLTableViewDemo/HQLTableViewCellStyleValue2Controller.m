//
//  HQLTableViewCellStyleValue2Controller.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTableViewCellStyleValue2Controller.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleValue2";

@interface HQLTableViewCellStyleValue2Controller ()

@end

@implementation HQLTableViewCellStyleValue2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Value2 样式";
    
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 根据重用标识符找到可重用的 cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    
    // 如果没有可重用的 cell，则手动创建 Value1 样式的 cell
    if (!cell) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellReuseIdentifier];
      }

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
