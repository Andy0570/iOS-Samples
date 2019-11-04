//
//  HQLSearchViewController.m
//  PersonalCenterDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "HQLSearchViewController.h"

// Frameworks
#import <YYKit/NSObject+YYModel.h>

// Controllers
#import "HQLFileManagerViewController.h"
#import "HQLConvertPathViewController.h"
#import "HQLFileBasicUsageViewController.h"
#import "HQLFIleManagerUsuallyMethodViewController.h"

#import "HQLPersistenceViewController.h"
#import "HQLKeyArchiverViewController.h"
#import "HQLKeyArchiver2ViewController.h"

// Views
#import "UITableViewCell+ConfigureModel.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// cell 重用标识符
static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";


@interface HQLSearchViewController ()

@property (nonatomic, strong) NSArray *groupedModelsArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation HQLSearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 mainTableViewTitleModel.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)groupedModelsArray {
    if (!_groupedModelsArray) {
        // mainTableViewTitleModel.plist 文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"searchViewController" ofType:@"plist"];
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
    NSLog(@"section = %ld, row = %ld",(long)indexPath.section,(long)indexPath.row);
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
                    HQLFileManagerViewController *fmvc = [[HQLFileManagerViewController alloc] init];
                    [self.navigationController pushViewController:fmvc animated:YES];
                    break;
                }
                case 1: {
                    HQLConvertPathViewController *cpvc = [[HQLConvertPathViewController alloc] init];
                    [self.navigationController pushViewController:cpvc animated:YES];
                    break;
                }
                case 2: {
                    HQLFileBasicUsageViewController *fbvc = [[HQLFileBasicUsageViewController alloc] init];
                    [self.navigationController pushViewController:fbvc animated:YES];
                    break;
                }
                case 3: {
                    HQLFIleManagerUsuallyMethodViewController *fmvc = [[HQLFIleManagerUsuallyMethodViewController alloc] init];
                    [self.navigationController pushViewController:fmvc animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    HQLPersistenceViewController *vc = [[HQLPersistenceViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 1: {
                    HQLKeyArchiverViewController *vc = [[HQLKeyArchiverViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case 2: {
                    HQLKeyArchiver2ViewController *vc = [[HQLKeyArchiver2ViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
}

@end
