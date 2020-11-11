//
//  HQLSearchViewController.m
//  PersonalCenterDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "HQLSearchViewController.h"

// Controllers
#import "HQLContactsTableViewController.h"
#import "HQLContactWay2TableViewController.h"

#import "HQLExample1SearchController.h"
#import "HQLExample2SearchController.h"

#import "HQLCitySelectionViewController.h"
#import "HQLAddressPickerViewController.h"
#import "HQLChooseLocationViewController.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

// cell 重用标识符
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLSearchViewController ()
@property (nonatomic, strong) NSArray<HQLTableViewGroupedModel *> *groupedModels;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;
@end

@implementation HQLSearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 searchViewController.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray<HQLTableViewGroupedModel *> *)groupedModels {
    if (!_groupedModels) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"searchViewController.plist" modelsOfClass:HQLTableViewGroupedModel.class];
        _groupedModels = store.dataSourceArray;
    }
    return _groupedModels;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroups:self.groupedModels cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 通讯录搜索：UISearchBar 示例
        HQLContactsTableViewController *contactsTVC = [[HQLContactsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:contactsTVC animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        // 通讯录搜索：UISearcnController 示例
        HQLContactWay2TableViewController *contactsTVC = [[HQLContactWay2TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:contactsTVC animated:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 当前页展示搜索结果
        HQLExample1SearchController *example1 = [[HQLExample1SearchController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:example1 animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        // 跳转页展示搜索结果
        HQLExample2SearchController *example2 = [[HQLExample2SearchController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:example2 animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        // 城市选择器
        HQLCitySelectionViewController *citySelectionVC = [[HQLCitySelectionViewController alloc] init];
        [self.navigationController pushViewController:citySelectionVC animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        // 省市区三级联动1
        HQLAddressPickerViewController *viewController = [[HQLAddressPickerViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        // 省市区三级联动2
        HQLChooseLocationViewController *viewController = [[HQLChooseLocationViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
