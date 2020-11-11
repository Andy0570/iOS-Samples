//
//  MainTableViewController.m
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2020/11/07.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "MainTableViewController.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const plistFileName = @"mainTableViewTitleModel.plist";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface MainTableViewController ()
@property (nonatomic, strong) NSArray<HQLTableViewGroupedModel *> *groupedModels;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;
@end

@implementation MainTableViewController

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
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:plistFileName modelsOfClass:HQLTableViewGroupedModel.class];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"section = %ld, row = %ld",(long)indexPath.section,indexPath.row);
}

@end
