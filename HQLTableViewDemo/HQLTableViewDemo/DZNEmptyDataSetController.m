//
//  DZNEmptyDataSetController.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/19.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "DZNEmptyDataSetController.h"

// Controller
#import "HQLEmptyDataSetExample1.h"
#import "HQLEmptyDataSetExample2.h"
#import "HQLEmptyDataSetExample3.h"
#import "HQLEmptyDataSetExample4.h"
#import "HQLEmptyDataSetExample5.h"
#import "HQLEmptyDataSetExample6.h"
#import "HQLEmptyDataSetExample7.h"
#import "HQLEmptyDataSetExample8.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const kPlistFileName = @"emptyDataSetExample.plist";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface DZNEmptyDataSetController ()
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation DZNEmptyDataSetController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"DZNEmptyDataSet";
    [self setupTableView];
}

#pragma mark - Private

- (void)setupTableView {
    // 从 emptyDataSetExample.plist 文件中读取数据源，加载到 NSArray 类型的数组中
    HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:kPlistFileName modelsOfClass:HQLTableViewModel.class];
    
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItems:store.dataSourceArray cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HQLTableViewModel *currentModel = (HQLTableViewModel *)[self.arrayDataSource itemAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {
            HQLEmptyDataSetExample1 *tableView = [[HQLEmptyDataSetExample1 alloc] initWithStyle:UITableViewStylePlain];
            tableView.title = currentModel.title;
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 1: {
            HQLEmptyDataSetExample2 *tableView = [[HQLEmptyDataSetExample2 alloc] initWithStyle:UITableViewStylePlain];
            tableView.title = currentModel.title;
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 2: {
            HQLEmptyDataSetExample3 *tableView = [[HQLEmptyDataSetExample3 alloc] initWithStyle:UITableViewStylePlain];
            tableView.title = currentModel.title;
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 3: {
            HQLEmptyDataSetExample4 *tableView = [[HQLEmptyDataSetExample4 alloc] initWithStyle:UITableViewStylePlain];
            tableView.title = currentModel.title;
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 4: {
            HQLEmptyDataSetExample5 *tableView = [[HQLEmptyDataSetExample5 alloc] initWithStyle:UITableViewStylePlain];
            tableView.title = currentModel.title;
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 5: {
            HQLEmptyDataSetExample6 *tableView = [[HQLEmptyDataSetExample6 alloc] initWithStyle:UITableViewStylePlain];
            tableView.title = currentModel.title;
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 6: {
            HQLEmptyDataSetExample7 *tableView = [[HQLEmptyDataSetExample7 alloc] initWithStyle:UITableViewStylePlain];
            tableView.title = currentModel.title;
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 7: {
            HQLEmptyDataSetExample8 *tableView = [[HQLEmptyDataSetExample8 alloc] initWithStyle:UITableViewStylePlain];
            tableView.title = currentModel.title;
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        default:
            break;
    }
}


@end
