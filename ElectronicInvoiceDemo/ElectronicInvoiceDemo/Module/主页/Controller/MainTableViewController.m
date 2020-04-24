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
#import "DZFPOrderTableViewController.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Categories
#import "UITableViewCell+ConfigureModel.h"

// cell 重用标识符
static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@interface MainTableViewController ()

@property (nonatomic, copy) NSArray *groupedModelsArray;
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

// 列表数据源，从 plist 文件读取并返回
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
    // 配置 tableView 数据源，，通过 HQLGroupedArrayDataSource 类的实例实现数据源代理
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        // MARK: 调用范畴类中的方法设置视图对象的数据模型
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
    NSLog(@"section = %ld, row = %ld",indexPath.section,indexPath.row);
    
    // 该行对应的模型类
    HQLTableViewCellStyleDefaultModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    
    // 订单管理
    if (indexPath.section == 0 && indexPath.row == 0) {
        DZFPOrderTableViewController *tableVC = [[DZFPOrderTableViewController alloc] initWithStyle:UITableViewStylePlain];
        tableVC.title = cellModel.title; // 从模型类中获取并设置标题
        [self.navigationController pushViewController:tableVC animated:YES];
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // 1.没有登录，则跳转到登录页面
    // 2.已登录，跳转到登录成功后的个人页面
    NSLog(@"MainView :%s,%@",__func__,segue.identifier);
}

@end
