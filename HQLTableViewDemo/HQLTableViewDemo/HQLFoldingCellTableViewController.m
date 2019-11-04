//
//  HQLFoldingCellTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/16.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLFoldingCellTableViewController.h"
#import "HQLFoldingCell.h"

static const CGFloat kCloseCellHeight  = 179; // 折叠高度
static const CGFloat kOpenCellHeight = 488;   // 打开高度

@interface HQLFoldingCellTableViewController ()
{
    NSMutableArray *heightArray;
}

@end

@implementation HQLFoldingCellTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HQLFoldingCell class]) bundle:nil] forCellReuseIdentifier:@"foldingcell"];
    
    // 一个存放高度的数组
    heightArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [heightArray addObject:[NSNumber numberWithFloat:kCloseCellHeight]];
    }
}

#pragma mark - UITableViewDataSource

// 一共 10 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

// 每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [heightArray[indexPath.row] floatValue];
}

// 每一行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQLFoldingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foldingcell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[HQLFoldingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"foldingcell"];
    }
    if ([heightArray[indexPath.row] floatValue] == kCloseCellHeight) {
        [cell selectedAnimation:NO animation:NO completion:nil];
    } else {
        [cell selectedAnimation:YES animation:NO completion:nil];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

// 该行被选中时
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HQLFoldingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isAnimating]) return;
    
    CGFloat durtion = 0.0;
    if ([heightArray[indexPath.row] floatValue] == kCloseCellHeight) {
        // 折叠 -> 打开
        [heightArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:kOpenCellHeight]];
        durtion = 0.3;
        [cell selectedAnimation:YES animation:YES completion:nil];
    } else {
        // 打开 -> 折叠
        durtion = [cell returnSumTime];
        [heightArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:kCloseCellHeight]];
        [cell selectedAnimation:NO animation:YES completion:nil];
    }
    [UIView animateWithDuration:durtion + 0.3 animations:^{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
}

@end
