//
//  HQLEmptyDataSetExample6.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/1.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLEmptyDataSetExample6.h"

// Framework
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Chameleon.h>

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLEmptyDataSetExample6 () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HQLEmptyDataSetExample6

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
    return [UIImage imageNamed:@"placeholder_network_error_404"];
}

// MARK: 空白页显示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"您当前未连接网络";
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15.0],
        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#25282b"]
    };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

// MARK: 空白页添加按钮，设置按钮图片
- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [UIImage imageNamed:@"button_Image"];
}

// MARK: 空白页背景颜色
- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithHexString:@"#f0f3f5"];
}

#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // 处理空白页面按钮点击事件
    NSLog(@"处理空白页面按钮点击事件");
    
}


@end
