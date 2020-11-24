//
//  HQLMineTableViewController.m
//  UIAlertViewController
//
//  Created by Qilin Hu on 2020/4/21.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMineTableViewController.h"

// Controller
#import "HQLToastViewController.h"
#import "MBHudDemoViewController.h"
#import "ActionSheetPickerViewController.h"

// Model
#import "HQLTableViewCellGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMineTableViewController ()
@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation HQLMineTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开源框架";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 myTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)cellsArray {
    if (!_cellsArray) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"myTableViewTitleModel.plist" modelsOfClass:HQLTableViewModel.class];
        _cellsArray = store.dataSourceArray;
    }
    return _cellsArray;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源，通过 HQLArrayDataSource 类的实例实现数据源代理
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
            HQLToastViewController *toastVC = [[HQLToastViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:toastVC animated:YES];
            break;
        }
        case 1: {
            MBHudDemoViewController *hudDemoVC = [[MBHudDemoViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:hudDemoVC animated:YES];
            break;
        }
        case 2: {
            ActionSheetPickerViewController *actionSheetPickerVC = [[ActionSheetPickerViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:actionSheetPickerVC animated:YES];
            break;
        }
        case 3: {
            NSLog(@"第 %ld 行的标题：%@。\n",indexPath.row, cellModel.title);
            break;
        }
        case 4: {
            NSLog(@"第 %ld 行的标题：%@。\n",indexPath.row, cellModel.title);
            break;
        }
        default:
            break;
    }
}

@end
