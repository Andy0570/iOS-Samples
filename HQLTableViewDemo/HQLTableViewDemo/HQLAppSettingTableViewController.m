//
//  HQLAppSettingTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/1/20.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLAppSettingTableViewController.h"

// Controller
#import <Chameleon.h>
#import <YYKit.h>

// View
#import "HQLLogoutFooterView.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Utils
#import "HQLPropertyListStore.h"
#import "HQLArrayDataSource.h"
#import "UITableViewCell+ConfigureModel.h"

static NSString * const KPlistFileName = @"appSettingTableViewTitle.plist";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLAppSettingTableViewController ()

@property (nonatomic, copy) NSArray<HQLTableViewModel *> *dataSources;
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@property (nonatomic, strong) HQLLogoutFooterView *logoutFooterView;

@end

@implementation HQLAppSettingTableViewController

#pragma mark - Initialize

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) { return nil; }
    
    [self loadTableViewDataSource];
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) { return nil; }
    
    [self loadTableViewDataSource];
    return self;
}

- (void)loadTableViewDataSource {
    HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:KPlistFileName modelsOfClass:HQLTableViewModel.class];
    self.dataSources = store.dataSourceArray;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    [self setupTableView];
}

- (void)setupTableView {
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        self.automaticallyAdjustsScrollViewInsets = NO;
//#pragma clang diagnostic pop
//    }
    
    self.tableView.backgroundColor = rgb(249, 249, 249);
    
    // 配置 tableView 数据源，通过 HQLArrayDataSource 类的实例实现数据源代理
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItems:self.dataSources cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    self.tableView.rowHeight = 60.0f;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.tableFooterView = self.logoutFooterView;
}

#pragma mark - Custom Accessors

- (HQLLogoutFooterView *)logoutFooterView {
    if (!_logoutFooterView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, HQLLogoutFooterViewHeight);
        _logoutFooterView = [[HQLLogoutFooterView alloc] initWithFrame:frame];
        __weak __typeof(self)weakSelf = self;
        _logoutFooterView.logoutButtonActionBlock = ^{
            [weakSelf showLogoutAlertController];
        };
    }
    return _logoutFooterView;
}

#pragma mark - Actions

- (void)showLogoutAlertController {
//    HQLUserManager *sharedManager = [HQLUserManager sharedManager];
//    if (!sharedManager.isLogin) {
//        [self.navigationController.view makeToast:@"您当前还没有登录~"];
//        return;
//    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //[self removeAccessToken];
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <UITableViewDelegate>

/**
 MARK: 思考
 
 该示例中，尽管我通过 HQLPropertyListStore 从 plist 文件中读取数据源。
 通过 HQLArrayDataSource 处理 UITableViewDataSource 数据源，通过数据模型渲染 UITableViewCell 视图。
 
 但这里还是无法避免需要手动判断 cell 所对应的 action 点击事件，然后 push 相应的视图控制器。
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // when selected row of indexPath
    
    NSLog(@"%ld",indexPath.row);
    switch (indexPath.row) {
        case 0: {
            // 账号与安全
            
            break;
        }
        case 1: {
            // 消息设置
            
            break;
        }
        case 2: {
            // 通用设置
            
            break;
        }
        case 3: {
            // 常见问题
            
            break;
        }
        case 4: {
            // 意见反馈
            
            break;
        }
        case 5: {
            // 关于我们
            
            break;
        }
        default:
            break;
    }
}

@end
