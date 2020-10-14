//
//  HQLUITableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/5/11.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "HQLUITableViewController.h"

// Framework
#import <YYKit/NSObject+YYModel.h>

// Controller
#import "MainTableViewController.h"
#import "SecnodTableViewController.h"

#import "HQLTableViewCellStyleDefaultController.h"
#import "HQLTableViewCellStyleValue1Controller.h"
#import "HQLTableViewCellStyleValue2Controller.h"
#import "HQLTableViewCellStyleSubtitleController.h"

#import "HQLComment1TableViewController.h"
#import "HQLComment2TableViewController.h"
#import "HQLComment3TableViewController.h"

// View
#import "UITableViewCell+ConfigureModel.h"

// Model
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@interface HQLUITableViewController ()

@property (nonatomic, strong) NSArray *groupedModelsArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation HQLUITableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UITableView";
    [self setupTableView];
}

#pragma mark - Custom Accessors

- (NSArray *)groupedModelsArray {
    if (!_groupedModelsArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"UITableViewControllerModel" ofType:@"plist"];
        NSArray *jsonArray = [NSArray arrayWithContentsOfFile:path];
        _groupedModelsArray = [NSArray modelArrayWithClass:HQLTableViewCellGroupedModel.class json:jsonArray];
    }
    return _groupedModelsArray;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroupsArray:self.groupedModelsArray cellReuserIdentifier:cellReusreIdentifier configureBlock:^(UITableViewCell *cell, HQLTableViewCellStyleDefaultModel *model) {
        [cell hql_configureForModel:model];
    }];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 cell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReusreIdentifier];
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 0) {
        MainTableViewController *mainTVC = [[MainTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:mainTVC animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        SecnodTableViewController *secondTVC = [[SecnodTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:secondTVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        HQLTableViewCellStyleDefaultController *defaultTVC = [[HQLTableViewCellStyleDefaultController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:defaultTVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        HQLTableViewCellStyleValue1Controller *value1TVC = [[HQLTableViewCellStyleValue1Controller alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:value1TVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        HQLTableViewCellStyleValue2Controller *value2TVC = [[HQLTableViewCellStyleValue2Controller alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:value2TVC animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        HQLTableViewCellStyleSubtitleController *subtitleTVC = [[HQLTableViewCellStyleSubtitleController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:subtitleTVC animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        HQLComment1TableViewController *commentTVC = [[HQLComment1TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:commentTVC animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        HQLComment2TableViewController *commentTVC = [[HQLComment2TableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:commentTVC animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        HQLComment3TableViewController *commentTVC = [[HQLComment3TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:commentTVC animated:YES];
    } else {
        
    }
}

@end
