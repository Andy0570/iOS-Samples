//
//  HQLMainTableViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Frameworks
#import <Mantle.h>

// Controller
#import "HQLBaseWebViewController.h"
#import "HQLExample1ViewController.h"
#import "HQLExample2ViewController.h"
#import "HQLExample3ViewController.h"
#import "HQLExample4ViewController.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()

@property (nonatomic, strong) NSArray<HQLTableViewCellStyleDefaultModel *> *dataSourceArray;
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

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray<HQLTableViewCellStyleDefaultModel *> *)dataSourceArray {
    if (!_dataSourceArray) {

        // 1.构造 mainTableViewTitleModel.plist 文件 URL 路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"mainTableViewTitleModel.plist"];
        
        // 2.读取 mainTableViewTitleModel.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray;
        if (@available(iOS 11.0, *)) {
            NSError *readFileError = nil;
            jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
            NSAssert1(jsonArray, @"NSPropertyList File read error:\n%@", readFileError);
        } else {
            jsonArray = [NSArray arrayWithContentsOfURL:url];
            NSAssert(jsonArray, @"NSPropertyList File read error.");
        }
        
        // 3.将 jsonArray 数组中的 JSON 数据转换成 HQLTableViewCellGroupedModel 模型
        NSError *decodeError = nil;
        _dataSourceArray = [MTLJSONAdapter modelsOfClass:HQLTableViewCellGroupedModel.class
                                     fromJSONArray:jsonArray
                                             error:&decodeError];
        NSAssert1(_dataSourceArray, @"JSONArray decode error:\n%@", decodeError);
    }
    return _dataSourceArray;
}


#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroupsArray:self.dataSourceArray cellReuseIdentifier:cellReuseIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section = %ld, row = %ld",(long)indexPath.section,indexPath.row);
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                // 使用通用基类加载Web页面
                HQLBaseWebViewController *baseWebViewController = [[HQLBaseWebViewController alloc] init];
                NSURL *url = [NSURL URLWithString:@"https://www.jianshu.com/p/35be2053111c"];
                baseWebViewController.requestURL = url;
                [self.navigationController pushViewController:baseWebViewController animated:YES];
                break;
            }
            case 1: {
                // UITableView 与 WKWebView 混排 1
                HQLExample1ViewController *vc = [[HQLExample1ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2: {
                // UITableView 与 WKWebView 混排2
                HQLExample2ViewController *vc = [[HQLExample2ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3: {
                // UITableView 与 WKWebView 混排3
                HQLExample3ViewController *vc = [[HQLExample3ViewController alloc] initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 4: {
                // UITableView 与 WKWebView 混排4
                HQLExample4ViewController *vc = [[HQLExample4ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

@end
