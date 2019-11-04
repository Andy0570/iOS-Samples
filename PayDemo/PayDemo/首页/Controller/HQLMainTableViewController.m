//
//  HQLMainTableViewController.m
//  PayDemo
//
//  Created by Qilin Hu on 2019/7/25.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Frameworks
#import <YYKit/NSObject+YYModel.h>

// Controller
#import "HQLOrderTableViewController.h" // 订单示例页面
#import "HQLWeChatPayViewController.h" // 微信支付
#import "HQLAlipayViewController.h" // 支付宝原生支付
#import "HQLAlipayWebViewController.h" // 支付宝 H5 支付
#import "HQLICBCPayViewController.h" // 工行e支付


// Views
#import "UITableViewCell+ConfigureModel.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// cell 重用标识符
static NSString * const cellReusreIdentifier = @"HQLMainTableViewCell";

@interface HQLMainTableViewController ()

@property (nonatomic, strong) NSArray *groupedModelsArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    [self setupTableView];
}

#pragma mark - Custom Accessors

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
    NSLog(@"section = %ld, row = %ld",indexPath.section,indexPath.row);
    switch (indexPath.row) {
        case 0: {
            // 订单示例页面
            HQLOrderTableViewController *payViewController = [[HQLOrderTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:payViewController animated:YES];
            break;
        }
        case 1: {
            // 微信支付
            HQLWeChatPayViewController *weChatPayViewController = [[HQLWeChatPayViewController alloc] init];
            [self.navigationController pushViewController:weChatPayViewController animated:YES];
            break;
        }
        case 2: {
            // 支付宝原生支付
            HQLAlipayViewController *alipayViewController = [[HQLAlipayViewController alloc] init];
            [self.navigationController pushViewController:alipayViewController animated:YES];
            break;
        }
        case 3: {
            // 支付宝H5支付
            HQLAlipayWebViewController *alipayWebViewController = [[HQLAlipayWebViewController alloc] init];
            [self.navigationController pushViewController:alipayWebViewController animated:YES];
            break;
        }
        case 4: {
            // 工商银行
            HQLICBCPayViewController *icbcPayViewController = [[HQLICBCPayViewController alloc] init];
            [self.navigationController pushViewController:icbcPayViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
