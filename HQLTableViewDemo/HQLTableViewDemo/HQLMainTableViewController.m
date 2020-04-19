//
//  HQLMainTableViewController.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLMainTableViewController.h"
#import "HQLUITableViewController.h"              // UITableViewStyle 的两种样式示例代码
#import "HQLExpandAndShrinkTableViewController.h" // 展开收缩列表
#import "HQLContactsSearchTableViewController.h"  // 通讯录搜索
#import "HQListHegihtAdaptiveTableViewController.h" // 高度自适应

#import "HQLThirdTableViewController.h"           // 支付页面

#import "HQLViewController.h"                     // 九宫格布局按钮
#import "HQLAlertTableViewController.h"           // 弹窗视图

#import "HQLTitleTableViewController.h"           // 学习使用TableView

#import "HQLSSCardTableViewController.h"          // 卡包

#import "HQLDownloadViewController.h"             // NSURLSession

#import "HQLNetworkViewController.h"              // AFNetworking

#import "HQLFoldingCellTableViewController.h" // Folding Cell

#import "PageViewController.h"                   // UIPageControl 的学习使用


static NSString *reuserIdentifier = @"reuserTableViewCell";

@interface HQLMainTableViewController ()

/** 主视图列表的数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HQLMainTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"iOS列表的使用";
    [self setupTableView];
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
                       @"通讯录、搜索",
                       @"高度自适应",
                       @"支付页面",
                       @"九宫格布局按钮",
                       @"UIAlertViewController",
                       @"学习使用TableView",
                       @"卡包",
                       @"NSURLSession",
                       @"AFNetworking",
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
        case 2: // 通讯录搜索
        {
            HQLContactsSearchTableViewController *contactsSearchTVC = [[HQLContactsSearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:contactsSearchTVC animated:YES];
            break;
        }
        case 3: // 高度自适应
        {
            HQListHegihtAdaptiveTableViewController *heightAdaptiveTVC = [[HQListHegihtAdaptiveTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:heightAdaptiveTVC animated:YES];
            break;
        }
        case 4: // 支付页面
        {
            HQLThirdTableViewController *thirdTableViewController = [[HQLThirdTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:thirdTableViewController animated:YES];
            break;
        }
        
        case 5: // 九宫格布局按钮
        {
            HQLViewController *viewController = [[HQLViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 6: // 弹窗视图
        {
            HQLAlertTableViewController *alertViewController = [[HQLAlertTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:alertViewController animated:YES];
            break;
        }
        case 7: // 学习使用TableView
        {
            HQLTitleTableViewController *titleTableViewController = [[HQLTitleTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:titleTableViewController animated:YES];
            break;
        }
        case 8:
        {
            HQLSSCardTableViewController *sscradTableViewController = [[HQLSSCardTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:sscradTableViewController animated:YES];
            break;
        }
        case 9: // NSURLSession 的学习使用
        {
            HQLDownloadViewController *sessionViewController = [[HQLDownloadViewController alloc] init];
            [self.navigationController pushViewController:sessionViewController animated:YES];
            break;
        }
        case 10: // AFNetworking 的学习使用
        {
            HQLNetworkViewController *networkViewController = [[HQLNetworkViewController alloc] init];
            [self.navigationController pushViewController:networkViewController animated:YES];
            break;
        }
        case 11: // folding-cell
        {
            HQLFoldingCellTableViewController *controller = [[HQLFoldingCellTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 12: // UIPageControl 的学习使用
        {
            PageViewController *vc = [[PageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
