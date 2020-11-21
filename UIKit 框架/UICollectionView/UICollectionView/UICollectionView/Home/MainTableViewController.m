//
//  MainTableViewController.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/22.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "MainTableViewController.h"

// UICollectionViewController
#import "HQLGridButtonViewController.h"    // 九宫格布局按钮
#import "FirstCollectionViewController.h"  // 基础使用示例
#import "SecondCollectionViewController.h" // 引导页
#import "ThirdCollectionViewController.h"  // 瀑布流
#import "CHTCollectionViewController.h"    // 瀑布流示例2
#import "FourthCollectionViewController.h" // 使用代理方式设置布局参数
#import "CustomCollectionViewController.h" // 翻页查看图片效果
#import "RGCardCollectionViewController.h" // 3D效果卡片切换
#import "HQLPhoneViewController.h"         // 相册重新排序
#import "HQLActivityDetailViewController.h" // 活动示例
#import "HQLMainPageMenu.h" // 首页示例

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface MainTableViewController ()
@property (nonatomic, strong) NSArray *dataSourceArray;
@end

@implementation MainTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"九宫格布局按钮",
                             @"基础使用",
                             @"引导页",
                             @"瀑布流",
                             @"瀑布流示例2",
                             @"使用代理方式设置布局参数",
                             @"翻页查看图片效果",
                             @"3D效果卡片切换",
                             @"相册重新排序",
                             @"活动示例",
                             @"首页示例"];
    }
    return _dataSourceArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            // 九宫格布局按钮
            HQLGridButtonViewController *vc = [[HQLGridButtonViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            // 基础使用
            FirstCollectionViewController *viewController = [[FirstCollectionViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 2: {
            // 引导页
            SecondCollectionViewController *viewController = [[SecondCollectionViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 3: {
            // 瀑布流
            ThirdCollectionViewController *viewController = [[ThirdCollectionViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 4: {
            // 瀑布流示例2
            CHTCollectionViewController *vc = [[CHTCollectionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5: {
            // 使用代理方式设置布局参数
            FourthCollectionViewController *viewController = [[FourthCollectionViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 6: {
            // 翻页查看图片效果
            CustomCollectionViewController *viewController = [[CustomCollectionViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 7: {
            // 3D 效果卡片切换
            RGCardCollectionViewController *viewController = [[RGCardCollectionViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 8: {
            // 相册重新排序
            HQLPhoneViewController *vc = [[HQLPhoneViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 9: {
            // 活动示例
            HQLActivityDetailViewController *vc = [[HQLActivityDetailViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 10: {
            // 首页示例
            HQLMainPageMenu *pageMenu = [[HQLMainPageMenu alloc] init];
            [self.navigationController pushViewController:pageMenu animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
