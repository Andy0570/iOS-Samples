//
//  MainTableViewController.m
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/3/31.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "MainTableViewController.h"

// Frameworks
#import <YYKit/NSObject+YYModel.h>

// Controllers
#import "HQLTakePhotoViewController.h" // UIImagePickerController 拍照
#import "HQLAVFoundationViewController.h" // AVFoundation 拍照
#import "HQLFaceDetectiveViewController.h" // 人脸识别
#import "HQLPingAn423ViewController.h"     // 平安SDK


// Views
#import "UITableViewCell+ConfigureModel.h"

// Models
#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"
#import "HQLGroupedArrayDataSource.h"

static NSString * const cellReusreIdentifier = @"UITableViewCellStyleDefault";

@interface MainTableViewController ()

@property (nonatomic, copy) NSArray *groupedModelsArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;

@end

@implementation MainTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"橙子";
    [self setupTableView];
}

#pragma mark - Custom Accessors

- (NSArray *)groupedModelsArray {
    if (!_groupedModelsArray) {
        // 读取 mainTableViewTitleModel.plist 文件，并存放进 jsonArray 数组
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mainTableViewTitleModel" ofType:@"plist"];
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReusreIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        // UIImagePickerController
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    // 照片
                    HQLTakePhotoViewController *takePhotoVC = [[HQLTakePhotoViewController alloc] init];
                    [self.navigationController pushViewController:takePhotoVC animated:YES];
                    break;
                }
                case 1: {
                    // 视频
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"视频示例还没做" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:alertAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        // AVFoundation
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    // 照片
                    HQLAVFoundationViewController *takePhotoVC = [[HQLAVFoundationViewController alloc] init];
                    takePhotoVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:takePhotoVC animated:YES];
                    break;
                }
                case 1: {
                    // 视频
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        // 人脸识别
        case 2: {
            HQLFaceDetectiveViewController *faceDectiveViewController = [[HQLFaceDetectiveViewController alloc] init];
            [self.navigationController pushViewController:faceDectiveViewController animated:YES];
            break;
        }
        // 第三方框架活体检测
        case 3: {
            switch (indexPath.row) {
                case 0: {
                    // 商汤SDK
                    
                    
                    break;
                }
                case 1: {
                    // 平安SDK 4.2.3
                    HQLPingAn423ViewController *paViewController = [[HQLPingAn423ViewController alloc] init];
                    [self.navigationController pushViewController:paViewController animated:YES];
                    
                    break;
                }
                default:
                    break;
            }
        }
        default:
            break;
    }
}


@end
