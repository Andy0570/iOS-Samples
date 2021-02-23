//
//  HQLMineTableViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMineTableViewController.h"

// Controller
#import "RSKExampleViewController.h"
#import "HQLPhotoPickerTableViewController.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const plistFileName = @"myTableViewTitleModel.plist";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMineTableViewController ()
@property (nonatomic, copy) NSArray<HQLTableViewModel *> *cellModels;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation HQLMineTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 点击某一行时，可以取出该行的数据模型，读取相关属性
    HQLTableViewModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            // RSKImageCropper 框架示例代码
            RSKExampleViewController *vc = [[RSKExampleViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            // HXPhotoPicker 示例
            HQLPhotoPickerTableViewController *photoPickerVC = [[HQLPhotoPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:photoPickerVC animated:YES];
            break;
        }
        case 2: {
            NSLog(@"第 %ld 行的标题：%@。\n",indexPath.row, cellModel.title);
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
