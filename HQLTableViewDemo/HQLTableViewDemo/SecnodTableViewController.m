//
//  SecnodTableViewController.m
//  UITableViewControllerDemo
//
//  Created by Qilin Hu on 2018/4/2.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "SecnodTableViewController.h"

// Model
#import "HQLTableViewCellGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface SecnodTableViewController ()

@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;

@end

@implementation SecnodTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
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
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 1: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 2: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 3: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 4: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 5: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 6: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 7: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 8: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 9: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 10: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 11: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 12: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 13: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 14: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 15: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 16: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 17: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 18: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 19: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        default:
            break;
    }
}

@end
