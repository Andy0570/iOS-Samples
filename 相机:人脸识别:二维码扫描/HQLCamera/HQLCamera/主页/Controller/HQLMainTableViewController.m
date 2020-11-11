//
//  HQLMainTableViewController.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLMainTableViewController.h"

// Controller
// UIImagePickerController 示例
#import "HQLTakePhotoViewController.h"
#import "HQLCamera01ViewController.h"
#import "HQLCamera02ViewController.h"
#import "HQLCamera03ViewController.h"

// AVFoundation 示例
#import "HQLAVFoundation01ViewController.h"
#import "HQLAVFoundation02ViewController.h"
// 人脸识别
#import "HQLFaceDetectorViewController.h"

// PHPickerViewController 示例
#import "HQLPicker01ViewController.h"

// 二维码扫描示例
#import "HQLScanQRCodeViewController.h"

// Models
#import "HQLTableViewGroupedModel.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Store
#import "HQLPropertyListStore.h"

static NSString * const plistFileName = @"mainTableViewTitleModel.plist";
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMainTableViewController ()
@property (nonatomic, strong) NSArray<HQLTableViewGroupedModel *> *groupedModels;
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

- (NSArray<HQLTableViewGroupedModel *> *)groupedModels {
    if (!_groupedModels) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:plistFileName modelsOfClass:HQLTableViewGroupedModel.class];
        _groupedModels = store.dataSourceArray;
    }
    return _groupedModels;
}

#pragma mark - Private

- (void)setupTableView {
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroups:self.groupedModels cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // MARK: UIImagePickerController 示例
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                HQLTakePhotoViewController *vc = [[HQLTakePhotoViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1: {
                HQLCamera01ViewController *vc = [[HQLCamera01ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2: {
                HQLCamera02ViewController *vc = [[HQLCamera02ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3: {
                HQLCamera03ViewController *vc = [[HQLCamera03ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }
    
    // MARK: AVFoundation 示例
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                HQLAVFoundation01ViewController *vc = [[HQLAVFoundation01ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1: {
                HQLAVFoundation02ViewController *vc = [[HQLAVFoundation02ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2: {
                HQLFaceDetectorViewController *vc = [[HQLFaceDetectorViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }
    
    // MARK: PHPickerViewController 示例
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                HQLPicker01ViewController *vc = [[HQLPicker01ViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1: {

                break;
            }
            case 2: {
                
                break;
            }
            default:
                break;
        }
    }
    
    // MARK: 二维码扫描示例
    if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0: {
                HQLScanQRCodeViewController *vc = [[HQLScanQRCodeViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1: {

                break;
            }
            case 2: {
                
                break;
            }
            default:
                break;
        }
    }
}

@end
