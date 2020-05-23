//
//  HQLChildTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/5/20.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "HQLChildTableViewController.h"

// Framework
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <Chameleon.h>

@interface HQLChildTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HQLChildTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - Private


#pragma mark - <UITableViewDataSource>

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - <DZNEmptyDataSetSource>

#pragma mark 空白页显示图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"alipayLogo"];
}

#pragma mark 空白页显示详细描述
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    // NSString *text = self.emptyDescription;
    
    NSString *text = @"当前页面内容为空！！！";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSForegroundColorAttributeName:HexColor(@"#A6A6A6"),
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


#pragma mark - <DZNEmptyDataSetDelegate>

#pragma mark 是否显示空白页视图
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    // MJRefresh 错误：isRefreshing 永远返回 YES
    // BOOL isRefreshing = self.tableView.mj_header.isRefreshing;
    // return (isRefreshing ? NO : YES);
    return YES;
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    return YES;
}

@end
