//
//  HQLEmptyDataSetExample3.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/1.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLEmptyDataSetExample3.h"

// Framework
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Chameleon.h>

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLEmptyDataSetExample3 () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HQLEmptyDataSetExample3

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
    return [UIImage imageNamed:@"placeholder_no_network"];
}

// MARK: 空白页添加按钮，设置按钮文字
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    // 设置按钮标题
    NSString *buttonTitle = @"网络不给力，请点击重试哦~";

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
    // 设置所有字体大小为 #15
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:15.0]
                             range:NSMakeRange(0, buttonTitle.length)];
    // 设置所有字体颜色为浅灰色
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor lightGrayColor]
                             range:NSMakeRange(0, buttonTitle.length)];
    // 设置指定4个字体为蓝色
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:HexColor(@"#007EE5")
                             range:NSMakeRange(7, 4)];
    return attributedString;
    
}

// MARK: 空白页背景颜色
- (nullable UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithHexString:@"#f0f3f5"];
}

// MARK: 设置空白页内容的垂直便宜量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70.0f;
}

#pragma mark - <DZNEmptyDataSetDelegate>

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    // 处理空白页面按钮点击事件
    NSLog(@"处理空白页面按钮点击事件");
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.tableView.contentOffset = CGPointZero;
}

@end
