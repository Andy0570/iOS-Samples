//
//  HQLMainTableViewController.m
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/21.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Frameworks
#import <YYKit/NSObject+YYModel.h>

// Controllers
#import "HQLDemo1ViewController.h"
#import "HQLDemo2ViewController.h"
#import "HQLDemo3ViewController.h"
#import "HQLDemo4ViewController.h"
#import "HQLDemo5ViewController.h"
#import "HQLDemo6ViewController.h"
#import "HQLDemo7ViewController.h"
#import "HQLDemo8ViewController.h"

// Models
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

static NSString * const cellReuserIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;

@end

@implementation HQLMainTableViewController


- (void)dealloc {
    // 1⃣️ 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"NSURLSession";
    [self setupTableView];
    
    // 1⃣️ APP 进入后台后隐藏 Alert 弹窗
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
    }];
}

#pragma mark - Custom Accessors

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)cellsArray {
    if (!_cellsArray) {
        // myTableViewTitleModel.plist 文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mainTableViewTitleModel"
                                                         ofType:@"plist"];
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
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItemsArray:self.cellsArray cellReuserIdentifier:cellReuserIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuserIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            // NSURLSessionDataTask 示例
            HQLDemo1ViewController *vc = [[HQLDemo1ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            // NSURLSessionDownloadTask 下载任务
            HQLDemo2ViewController *vc = [[HQLDemo2ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            // NSURLSessionUploadTask 上传任务
            HQLDemo3ViewController *vc = [[HQLDemo3ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            // NSURLSessionDataTask 发送 GET 请求
            HQLDemo4ViewController *vc = [[HQLDemo4ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            // NSURLSessionDataTask 发送 POST 请求
            HQLDemo5ViewController *vc = [[HQLDemo5ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            // NSURLSessionDataTask 设置代理发送请求
            HQLDemo6ViewController *vc = [[HQLDemo6ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:
        {
            // 示例：获取新闻列表
            HQLDemo7ViewController *vc = [[HQLDemo7ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 7:
        {
            // 创建多种下载任务
            HQLDemo8ViewController *vc = [[HQLDemo8ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
