//
//  HQLMainTableViewController.m
//  CoreLocationDemo
//
//  Created by Qilin Hu on 2020/11/23.
//

#import "HQLMainTableViewController.h"

// Controller
#import "HQLMapViewController.h"
#import "CoreLocationViewController.h"

// Model
#import "HQLTableViewCellGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地图定位";
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
    
    HQLTableViewModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            HQLMapViewController *mapVC = [[HQLMapViewController alloc] init];
            mapVC.title = cellModel.title;
            [self.navigationController pushViewController:mapVC animated:YES];
            break;
        }
        case 1: {
            CoreLocationViewController *coreLocationVC = [[CoreLocationViewController alloc] initWithStyle:UITableViewStylePlain];
            coreLocationVC.title = cellModel.title;
            [self.navigationController pushViewController:coreLocationVC animated:YES];
            break;
        }
        case 2: {
            
            break;
        }
        case 3: {
            
            break;
        }
        case 4: {
            
            break;
        }
        default:
            break;
    }
}

@end
