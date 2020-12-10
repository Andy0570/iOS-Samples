//
//  HQLMainTableViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Controller
#import "HQLSandBoxPathViewController.h"
#import "HQLConvertPathViewController.h"
#import "HQLFileBasicUsageViewController.h"
#import "HQLFIleManagerUsuallyMethodViewController.h"

#import "HQLUserDefaultsViewController.h"
#import "HQLKeyArchiverViewController.h"

// Model
#import "HQLTableViewCellGroupedModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, strong) NSArray<HQLTableViewGroupedModel *> *groupedModels;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray<HQLTableViewGroupedModel *> *)groupedModels {
    if (!_groupedModels) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"mainTableViewTitleModel.plist" modelsOfClass:HQLTableViewGroupedModel.class];
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
    
    // 点击某一行时，可以取出该行的数据模型，读取相关属性
    HQLTableViewModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        HQLSandBoxPathViewController *vc = [[HQLSandBoxPathViewController alloc] init];
        vc.title = cellModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        HQLConvertPathViewController *vc = [[HQLConvertPathViewController alloc] init];
        vc.title = cellModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        HQLFileBasicUsageViewController *vc = [[HQLFileBasicUsageViewController alloc] init];
        vc.title = cellModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        HQLFIleManagerUsuallyMethodViewController *vc = [[HQLFIleManagerUsuallyMethodViewController alloc] init];
        vc.title = cellModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        HQLUserDefaultsViewController *vc = [[HQLUserDefaultsViewController alloc] init];
        vc.title = cellModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        HQLKeyArchiverViewController *vc = [[HQLKeyArchiverViewController alloc] init];
        vc.title = cellModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        
    }
}

@end
