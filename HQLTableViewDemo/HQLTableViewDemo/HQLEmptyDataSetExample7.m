//
//  HQLEmptyDataSetExample7.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/1.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLEmptyDataSetExample7.h"

// Framework
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLEmptyDataSetExample7 () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HQLEmptyDataSetExample7

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
    return [UIImage imageNamed:@"placeholder_heart"];
}

// MARK: 设置图片动画: 缩放动画
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.duration = 1.25;
    animation.cumulative = NO;
    animation.repeatCount = MAXFLOAT;
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 45, 45)];

    return animation;
}

#pragma mark - DZNEmptyDataSetDelegate

// 向代理请求图像视图动画权限。 默认值为NO。
// 确保从 imageAnimationForEmptyDataSet 返回有效的 CAAnimation 对象：
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return YES;
}

@end
