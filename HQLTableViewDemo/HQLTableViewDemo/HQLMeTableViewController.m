//
//  HQLMeTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLMeTableViewController.h"

// Controller
#import "HQLLabelTableViewController.h"
#import "HQLButtonTableViewController.h"

#import "HQLMeDemo1TableViewController.h"
#import "HQLRegisterViewController.h"
#import "HQLRegixViewController.h"
#import "HQLFeedbackViewController.h"
#import "HQLCodeResignViewController.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMeTableViewController ()
@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation HQLMeTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = nil;
    [self setupTableView];
}

#pragma mark - Custom Accessors

- (NSArray *)cellsArray {
    if (!_cellsArray) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"meTableViewList.plist" modelsOfClass:HQLTableViewModel.class];
        _cellsArray = store.dataSourceArray;
    }
    return _cellsArray;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItems:self.cellsArray cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

// tableView 中的某一行cell被点击时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 点击某一行时，可以取出该行的数据模型，读取相关属性
    HQLTableViewModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            // UILabel 使用示例
            HQLLabelTableViewController *vc = [[HQLLabelTableViewController alloc] initWithStyle:UITableViewStylePlain];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            // UIButton 使用示例
            HQLButtonTableViewController *vc = [[HQLButtonTableViewController alloc] initWithStyle:UITableViewStylePlain];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            // headerView 下拉放大效果
            HQLMeDemo1TableViewController *vc = [[HQLMeDemo1TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            // 注册页面示例
            HQLRegisterViewController *vc = [[HQLRegisterViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4: {
            // 意见反馈
            HQLFeedbackViewController *vc = [[HQLFeedbackViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5: {
            // 正则表达式
            HQLRegixViewController *vc = [[HQLRegixViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6: {
            HQLCodeResignViewController *vc = [[HQLCodeResignViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
