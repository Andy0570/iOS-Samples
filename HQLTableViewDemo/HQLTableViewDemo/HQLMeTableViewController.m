//
//  HQLMeTableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLMeTableViewController.h"

// Controller
#import "HQLLabelTableViewController.h"
#import "HQLButtonTableViewController.h"
#import "HQLImageTableViewController.h"
#import "HQLTextFieldTableViewController.h"
#import "HQLSegmentViewUsageController.h" // UISegmentControl 使用示例
#import "HQLSliderViewController.h"
#import "HQLSwitchViewController.h"

#import "HQLMeDemo1TableViewController.h"
#import "HQLRegisterViewController.h"
#import "HQLRegixViewController.h"
#import "HQLFeedbackViewController.h"
#import "HQLTagViewController.h"

#import "HQLPrivacyPolicyViewController.h"
#import "HQLUserServiceAgreementViewController.h"


// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const kPlistFileName = @"meTableViewList.plist";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMeTableViewController ()
@property (nonatomic, strong) HQLArrayDataSource *arrayDataSource;
@end

@implementation HQLMeTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = nil;
    [self setupTableView];
}

#pragma mark - Private

- (void)setupTableView {
    // 从 meTableViewList.plist 文件中读取数据源，加载到 NSArray 类型的数组中
    HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:kPlistFileName modelsOfClass:HQLTableViewModel.class];
    
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLArrayDataSource alloc] initWithItems:store.dataSourceArray cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 点击某一行时，可以取出该行的数据模型，读取相关属性
    HQLTableViewModel *cellModel = [self.arrayDataSource itemAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: {
            // UILabel 使用示例
            HQLLabelTableViewController *vc = [[HQLLabelTableViewController alloc] initWithStyle:UITableViewStylePlain];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            // UIButton 使用示例
            HQLButtonTableViewController *vc = [[HQLButtonTableViewController alloc] initWithStyle:UITableViewStylePlain];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            // UIImage 使用示例
            HQLImageTableViewController *vc = [[HQLImageTableViewController alloc] initWithStyle:UITableViewStylePlain];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3: {
            // UITextField 使用示例
            HQLTextFieldTableViewController *vc = [[HQLTextFieldTableViewController alloc] initWithStyle:UITableViewStylePlain];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4: {
            // UISegmentControl 使用示例
            HQLSegmentViewUsageController *vc = [[HQLSegmentViewUsageController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5: {
            // headerView 下拉放大效果
            HQLMeDemo1TableViewController *vc = [[HQLMeDemo1TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6: {
            // 注册页面示例
            HQLRegisterViewController *vc = [[HQLRegisterViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 7: {
            // 意见反馈
            HQLFeedbackViewController *vc = [[HQLFeedbackViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 8: {
            // 正则表达式
            HQLRegixViewController *vc = [[HQLRegixViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 9: {
            // Tag 标签
            HQLTagViewController *vc = [[HQLTagViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 10: {
            // 隐私政策
            HQLPrivacyPolicyViewController *vc = [[HQLPrivacyPolicyViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 11: {
            // 用户协议
            HQLUserServiceAgreementViewController *vc = [[HQLUserServiceAgreementViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 12: {
            // UISlider 示例
            HQLSliderViewController *vc = [[HQLSliderViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 13: {
            // UISwitch 示例
            HQLSwitchViewController *vc = [[HQLSwitchViewController alloc] init];
            vc.title = cellModel.title;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
