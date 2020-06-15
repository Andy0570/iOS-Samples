//
//  HQLMeTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLMeTableViewController.h"

// Frameworks
#import <YYKit/NSObject+YYModel.h>

// Controllers
#import "HQLMeDemo1TableViewController.h"
#import "HQLRegixViewController.h"

// Views
#import "UITableViewCell+ConfigureModel.h"

// Models
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLArrayDataSource.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMeTableViewController ()

@property (nonatomic, copy) NSArray *cellsArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;

@end

@implementation HQLMeTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = nil;
    [self setupTableView];
}

#pragma mark - Custom Accessors

- (NSArray *)cellsArray {
    if (!_cellsArray) {
        // myTableViewTitleModel.plist 文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"meTableViewList" ofType:@"plist"];
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
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItemsArray:self.cellsArray cellReuserIdentifier:cellReusreIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReusreIdentifier];
    
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
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            HQLMeDemo1TableViewController *meTVC = [[HQLMeDemo1TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:meTVC animated:YES];
            break;
        }
        case 1: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 2: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            HQLRegixViewController *vc = [[HQLRegixViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 4: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 5: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 6: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 7: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 8: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 9: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        case 10: {
            NSLog(@"第 %ld 行的标题：%@。\n",(long)indexPath.row, cellModel.title);
            break;
        }
        default:
            break;
    }
    
}

@end
