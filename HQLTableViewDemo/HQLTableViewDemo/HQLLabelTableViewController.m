//
//  HQLLabelTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLLabelTableViewController.h"

// Controllers
#import "LabelBasicUsageViewController.h"
#import "LabelCornerBorderViewController.h"
#import "LabelAttributesViewController.h"
#import "HQLSystemFontViewController.h"
#import "HQLSystemFontWeightViewController.h"
#import "HQLYYLabelTestViewController.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLLabelTableViewController ()
@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation HQLLabelTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"UILabel Usage";
    [self setupTableView];
}

#pragma mark - Custom Accessors

- (NSArray *)cellsArray {
    if (!_cellsArray) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"label.plist" modelsOfClass:HQLTableViewModel.class];
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
            // 基础用法
            LabelBasicUsageViewController *vc = [[LabelBasicUsageViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            // 圆角和边框
            LabelCornerBorderViewController *vc = [[LabelCornerBorderViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            // 属性字符串
            LabelAttributesViewController *vc = [[LabelAttributesViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            // 查看系统所有字体
            HQLSystemFontViewController *vc = [[HQLSystemFontViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4: {
            // 系统字重
            HQLSystemFontWeightViewController *vc = [[HQLSystemFontWeightViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5: {
            // YYLabel 框架
            HQLYYLabelTestViewController *vc = [[HQLYYLabelTestViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
