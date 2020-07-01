//
//  HQLMessageViewController.m
//  PersonalCenterDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "HQLMessageViewController.h"

// Framework
#import <YYKit/NSObject+YYModel.h>

// Controller
#import "HQLEmptyDataSetExample1.h"
#import "HQLEmptyDataSetExample2.h"
#import "HQLEmptyDataSetExample3.h"
#import "HQLEmptyDataSetExample4.h"
#import "HQLEmptyDataSetExample5.h"
#import "HQLEmptyDataSetExample6.h"
#import "HQLEmptyDataSetExample7.h"
#import "HQLEmptyDataSetExample8.h"

// Views
#import "UITableViewCell+ConfigureModel.h"

// Model
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLArrayDataSource.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMessageViewController ()

@property (nonatomic, copy) NSArray *dataSourceArray;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;

@end

@implementation HQLMessageViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"空白数据集示例";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 messageTableView.plist 文件中读取数据源，加载到 NSArray 类型的数组中
- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        // 1.构造 messageTableView.plist 文件 URL 路径
        NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        NSURL *url = [bundleURL URLByAppendingPathComponent:@"messageTableView.plist"];
        
        // 2.读取 messageTableView.plist 文件，并存放进 jsonArray 数组
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
        _dataSourceArray = [NSArray modelArrayWithClass:[HQLTableViewCellStyleDefaultModel class]
                                                   json:jsonArray];
    }
    return _dataSourceArray;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItemsArray:self.dataSourceArray cellReuserIdentifier:cellReuseIdentifier configureBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReuseIdentifier];
    
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HQLEmptyDataSetExample1 *tableView = [[HQLEmptyDataSetExample1 alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 1: {
            HQLEmptyDataSetExample2 *tableView = [[HQLEmptyDataSetExample2 alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 2: {
            HQLEmptyDataSetExample3 *tableView = [[HQLEmptyDataSetExample3 alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 3: {
            HQLEmptyDataSetExample4 *tableView = [[HQLEmptyDataSetExample4 alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 4: {
            HQLEmptyDataSetExample5 *tableView = [[HQLEmptyDataSetExample5 alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 5: {
            HQLEmptyDataSetExample6 *tableView = [[HQLEmptyDataSetExample6 alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 6: {
            HQLEmptyDataSetExample7 *tableView = [[HQLEmptyDataSetExample7 alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        case 7: {
            HQLEmptyDataSetExample8 *tableView = [[HQLEmptyDataSetExample8 alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:tableView animated:YES];
            break;
        }
        default:
            break;
    }
}


@end
