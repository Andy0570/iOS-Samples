//
//  HQLMessageViewController.m
//  PersonalCenterDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "HQLMessageViewController.h"

// Controller
#import "RWLoginViewController.h"


// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMessageViewController ()
@property (nonatomic, copy) NSArray *dataSourceArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation HQLMessageViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"空白数据集示例";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 messageTableView.plist 文件中读取数据源，加载到 NSArray 类型的数组中
- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"messageTableView.plist" modelsOfClass:HQLTableViewModel.class];
        _dataSourceArray = store.dataSourceArray;
    }
    return _dataSourceArray;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItems:self.dataSourceArray cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        // ReactiveCocoa 教程权威介绍-第1/2部分
        RWLoginViewController *controller = [[RWLoginViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        
    }  else if (indexPath.section == 0 && indexPath.row == 1) {

    }  else if (indexPath.section == 0 && indexPath.row == 2) {
        
    }  else if (indexPath.section == 0 && indexPath.row == 3) {
        
    }  else if (indexPath.section == 0 && indexPath.row == 4) {
        
    }  else if (indexPath.section == 0 && indexPath.row == 5) {
        
    }
}

@end
