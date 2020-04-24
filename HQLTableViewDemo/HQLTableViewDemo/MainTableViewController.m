//
//  MainTableViewController.m
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/3/31.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "MainTableViewController.h"

// Frameworks
#import <YYKit/NSObject+YYModel.h>

// Controllers

// Views
#import "UITableViewCell+ConfigureModel.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// cell 重用标识符
static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@interface MainTableViewController ()

@property (nonatomic, strong) NSArray *groupedModelsArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation MainTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)groupedModelsArray {
    if (!_groupedModelsArray) {
        // mainTableViewTitleModel.plist 文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mainTableViewTitleModel" ofType:@"plist"];
        // 读取 mainTableViewTitleModel.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray = [NSArray arrayWithContentsOfFile:path];
        // 将 jsonArray 数组中的 JSON 数据转换成 HQLTableViewCellGroupedModel 模型
        _groupedModelsArray = [NSArray modelArrayWithClass:[HQLTableViewCellGroupedModel class]
                                                      json:jsonArray];
    }
    return _groupedModelsArray;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroupsArray:self.groupedModelsArray cellReuserIdentifier:cellReusreIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReusreIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section = %ld, row = %ld",(long)indexPath.section,indexPath.row);
}


@end
