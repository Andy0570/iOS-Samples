//
//  HQLMineTableViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMineTableViewController.h"

// Frameworks
#import <Mantle.h>

// Controllers
#import "HQLHTMLDemo1ViewController.h"
#import "HQLHTMLDemo2ViewController.h"

// Models
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMineTableViewController ()

@property (nonatomic, copy) NSArray *cellsArray;
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

// 从 myTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)cellsArray {
    if (!_cellsArray) {
        // 1.构造 myTableViewTitleModel.plist 文件路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"myTableViewTitleModel.plist"];
        
        // 2.读取 myTableViewTitleModel.plist 文件，并存放进 jsonArray 数组
        NSArray *jsonArray;
        if (@available(iOS 11.0, *)) {
            NSError *readFileError = nil;
            jsonArray = [NSArray arrayWithContentsOfURL:url error:&readFileError];
            NSAssert1(jsonArray, @"NSPropertyList File read error:\n%@", readFileError);
        } else {
            jsonArray = [NSArray arrayWithContentsOfURL:url];
            NSAssert(jsonArray, @"NSPropertyList File read error.");
        }
        
        // 3.将 jsonArray 数组中的 JSON 数据转换成 HQLTableViewCellStyleDefaultModel 模型
        NSError *decodeError = nil;
        _cellsArray = [MTLJSONAdapter modelsOfClass:HQLTableViewCellStyleDefaultModel.class
                                      fromJSONArray:jsonArray
                                              error:&decodeError];
        NSAssert1(_cellsArray, @"JSONArray decode error:\n%@", decodeError);
    }
    return _cellsArray;
}


#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源，通过 HQLArrayDataSource 类的实例实现数据源代理
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItemsArray:self.cellsArray cellReuseIdentifier:cellReuseIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - UITableViewDelegate

// tableView 中的某一行cell被点击时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 点击某一行时，可以取出该行的数据模型，读取相关属性
    HQLTableViewCellStyleDefaultModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            NSLog(@"第 %ld 行的标题：%@。\n",indexPath.row, cellModel.title);
            HQLHTMLDemo1ViewController *vc = [[HQLHTMLDemo1ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            NSLog(@"第 %ld 行的标题：%@。\n",indexPath.row, cellModel.title);
            HQLHTMLDemo2ViewController *vc = [[HQLHTMLDemo2ViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
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
