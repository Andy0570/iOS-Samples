//
//  HQLPhotoPickerTableViewController.m
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/12.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLPhotoPickerTableViewController.h"

// Controller
#import "HQLPhotoPicker01ViewController.h"
#import "HQLPhotoPicker03ViewController.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const plistFileName = @"HXPhotoPickerTitleModel.plist";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLPhotoPickerTableViewController ()
@property (nonatomic, copy) NSArray<HQLTableViewModel *> *cellModels;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation HQLPhotoPickerTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"HXPhotoPicker 示例";
    [self setupTableView];
}

#pragma mark - Custom Accessors

- (NSArray<HQLTableViewModel *> *)cellModels {
    if (!_cellModels) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:plistFileName modelsOfClass:HQLTableViewModel.class];
        _cellModels = store.dataSourceArray;
    }
    return _cellModels;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源，通过 HQLArrayDataSource 类的实例实现数据源代理
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItems:self.cellModels cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 点击某一行时，可以取出该行的数据模型，读取相关属性
    HQLTableViewModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            HQLPhotoPicker01ViewController *photoPickerVC = [[HQLPhotoPicker01ViewController alloc] init];
            photoPickerVC.title = cellModel.title;
            [self.navigationController pushViewController:photoPickerVC animated:YES];
            break;
        }
        case 1: {
            HQLPhotoPicker03ViewController *photoPickerVC = [[HQLPhotoPicker03ViewController alloc] init];
            photoPickerVC.title = cellModel.title;
            [self.navigationController pushViewController:photoPickerVC animated:YES];
            break;
        }
        case 2: {
            
            break;
        }
        case 3: {
            
            break;
        }
        default:
            break;
    }
}



@end
