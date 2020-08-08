//
//  HQLMainTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Framework
#import <JKCategories.h>

#import "HQLUITableViewController.h"              // UITableViewStyle 的两种样式示例代码
#import "HQLExpandAndShrinkTableViewController.h" // 展开收缩列表

#import "HQListHegihtAdaptiveTableViewController.h" // 高度自适应

#import "HQLThirdTableViewController.h"           // 支付页面

#import "HQLTitleTableViewController.h"           // 学习使用TableView

#import "HQLSSCardTableViewController.h"          // 卡包

#import "HQLFoldingCellTableViewController.h" // Folding Cell

#import "PageViewController.h"                   // UIPageControl 的学习使用

// View
#import "HQLSuspensionBallManager.h"

static NSString *reuserIdentifier = @"reuserTableViewCell";

@interface HQLMainTableViewController () <HQLSuspensionBallDelegate>

/** 主视图列表的数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HQLMainTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"iOS列表的使用";
    [self setupTableView];
    
    [self addSuspensionBall];
}

// 添加悬浮球
- (void)addSuspensionBall {
    HQLSuspensionBallManager *manager = [HQLSuspensionBallManager sharedSuspensionBallManager];
    manager.delegate = self;
    [manager createSuspensionBall];
    [manager changeSuspensionBallAlpha:0.5];
}

- (void)setupTableView {
    // 注册TableViewCell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuserIdentifier];
    // 隐藏页脚视图分割线
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Custom Accessors

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObjects:
                       @"UITableViewController",
                       @"展开收缩列表",
                       @"高度自适应",
                       @"支付页面",
                       @"学习使用TableView",
                       @"卡包",
                       @"folding-cell",
                       @"UIPageControl",
                       nil];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier
                                                            forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 设置辅助指示箭头
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: // UITableViewStyle 的两种样式示例代码
        {
            HQLUITableViewController *tvc = [[HQLUITableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tvc animated:YES];
            break;
        }
        case 1: // 展开收缩列表
        {
            HQLExpandAndShrinkTableViewController *expandAndShrinkTableViewController = [[HQLExpandAndShrinkTableViewController alloc] init];
            [self.navigationController pushViewController:expandAndShrinkTableViewController animated:YES];
            break;
        }
        case 2: // 高度自适应
        {
            HQListHegihtAdaptiveTableViewController *heightAdaptiveTVC = [[HQListHegihtAdaptiveTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:heightAdaptiveTVC animated:YES];
            break;
        }
        case 3: // 支付页面
        {
            HQLThirdTableViewController *thirdTableViewController = [[HQLThirdTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:thirdTableViewController animated:YES];
            break;
        }
        case 4: // 学习使用TableView
        {
            HQLTitleTableViewController *titleTableViewController = [[HQLTitleTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:titleTableViewController animated:YES];
            break;
        }
        case 5:
        {
            HQLSSCardTableViewController *sscradTableViewController = [[HQLSSCardTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:sscradTableViewController animated:YES];
            break;
        }
        case 6: // folding-cell
        {
            HQLFoldingCellTableViewController *controller = [[HQLFoldingCellTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 7: // UIPageControl 的学习使用
        {
            PageViewController *vc = [[PageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - <HQLSuspensionBallDelegate>

- (void)suspensionBallClickAction:(HQLSuspensionBallManager *)suspensionBallManager {
    [self.view jk_makeToast:@"你点击了悬浮球"];
}

@end
