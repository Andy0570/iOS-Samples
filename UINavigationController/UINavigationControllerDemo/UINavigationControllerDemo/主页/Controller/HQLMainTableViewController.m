//
//  HQLMainTableViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMainTableViewController.h"
#import "HQLMainTableViewController+NavigationBar.h"

// Frameworks
#import <Mantle.h>

// Controller
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, strong) NSArray<HQLTableViewCellStyleDefaultModel *> *dataSourceArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.navigationItem.title = @"首页";
    [self hql_setupNavigationBar];
    
    [self setupTableView];
}


#pragma mark - Custom Accessors

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray<HQLTableViewCellStyleDefaultModel *> *)dataSourceArray {
    if (!_dataSourceArray) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"mainTableViewTitleModel.plist" modelsOfClass:HQLTableViewCellGroupedModel.class];
        _dataSourceArray = store.dataSourceArray;
    }
    return _dataSourceArray;
}


#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroupsArray:self.dataSourceArray cellReuseIdentifier:cellReuseIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section = %ld, row = %ld",(long)indexPath.section,indexPath.row);
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    FirstViewController *vc = [[FirstViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 1: {
                    SecondViewController *vc = [[SecondViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 2: {
                    ThirdViewController *vc = [[ThirdViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

@end
