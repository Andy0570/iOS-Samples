//
//  HQLEmptyDataSetExample1.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/1.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLEmptyDataSetExample1.h"

// Framework
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLEmptyDataSetExample1 () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HQLEmptyDataSetExample1

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

#pragma mark - Private

- (void)setupTableView {
    
    // DZNEmptyDataSet
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // 注册重用 cell（class 类型）
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏列表空白区域的分隔线
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

#pragma mark - <DZNEmptyDataSetSource>

// MARK: 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"lion"];
}

// MARK: 空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"狮子王";
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[UIColor darkGrayColor]
    };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

// MARK: 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"我只在必要时才勇敢，勇敢并不意味着要到处闯祸！";
  
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
        NSForegroundColorAttributeName:[UIColor lightGrayColor],
        NSParagraphStyleAttributeName:paragraph
    };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 向上偏移量为表头视图高度/2
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -64;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 50.0f;
}

@end
