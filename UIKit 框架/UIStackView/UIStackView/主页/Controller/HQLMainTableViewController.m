//
//  HQLMainTableViewController.m
//  UIStackView
//
//  Created by Qilin Hu on 2020/4/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Frameworks
#import <YYKit/NSObject+YYModel.h>
 
// Controllers
#import "HQLDemo1ViewController.h" // 1.app 评分提示
#import "HQLDemo2ViewController.h" // 2.使用 Size Class 适配 Stack View
#import "HQLDemo3ViewController.h" // 3. 使用 Mansonry 实现自动布局

// Models
#import "HQLTableViewCellStyleDefaultModel.h"
#import "HQLArrayDataSource.h"

// Others
#import "UITableViewCell+ConfigureModel.h"

static NSString * const cellReuserIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UIStackView 的使用示例";
    [self setupTableView];
}


#pragma mark - Custom Accessors

// 列表数据源，从 plist 文件读取并返回
- (NSArray *)cellsArray {
    if (!_cellsArray) {
        // myTableViewTitleModel.plist 文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mainTableViewTitleModel" ofType:@"plist"];
        // 读取 myTableViewTitleModel.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray = [NSArray arrayWithContentsOfFile:path];
        // 将 jsonArray 数组中的 JSON 数据转换成 HQLTableViewCellStyleDefaultModel 模型
        _cellsArray = [NSArray modelArrayWithClass:[HQLTableViewCellStyleDefaultModel class]
                                              json:jsonArray];
    }
    return _cellsArray;
}


#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源，通过 HQLArrayDataSource 类的实例实现数据源代理
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItemsArray:self.cellsArray cellReuserIdentifier:cellReuserIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuserIdentifier];
    
    // 隐藏 tableView 底部空白部分的线条
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 点击某一行时，可以取出该行的数据模型，读取相关属性
    HQLTableViewCellStyleDefaultModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            // 1.app 评分提示
            HQLDemo1ViewController *vc = [[HQLDemo1ViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case  1: {
            // 2.使用 Size Class 适配 Stack View
            HQLDemo2ViewController *vc = [[HQLDemo2ViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            // 3. 使用 Mansonry 实现自动布局
            HQLDemo3ViewController *vc = [[HQLDemo3ViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
