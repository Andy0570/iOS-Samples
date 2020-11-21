//
//  MineTableViewController.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/25.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "MineTableViewController.h"

// Controller
#import "AFViewController.h"
#import "AF2ViewController.h"
#import "AF22ViewController.h"
#import "AF23ViewController.h"
#import "AF24ViewController.h"
#import "AF25ViewController.h"
#import "AF26ViewController.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface MineTableViewController ()
@property (nonatomic, strong) NSArray *dataSourceArray;
@end

@implementation MineTableViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Custom Accessors

- (NSArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"1.理解 iOS 中的 Model-View-Controller",
                             @"2.1 使用 UICollectionView 显示内容(XIB)",
                             @"2.2 使用 UICollectionView 显示内容(code)",
                             @"2.3 UIScrollView 简要概述",
                             @"2.4 重用 UICollectionViewCell",
                             @"2.5 UICollectionViewCell 的视图层级",
                             @"2.6 使用 storyboary 和 xib 创建单元格"];
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

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            AFViewController *controller = [[AFViewController alloc] initWithNibName:NSStringFromClass(AFViewController.class) bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 1: {
            AF2ViewController *controller = [[AF2ViewController alloc] initWithNibName:NSStringFromClass(AF2ViewController.class) bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 2: {
            // 初始化集合视图布局
            UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
            collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
            collectionViewLayout.itemSize = CGSizeMake(20, 50);
            
            // 初始化集合视图
            AF22ViewController *viewController = [[AF22ViewController alloc] initWithCollectionViewLayout:collectionViewLayout];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 3: {
            AF23ViewController *viewController = [[AF23ViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 4: {
            UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
            AF24ViewController *viewController = [[AF24ViewController alloc] initWithCollectionViewLayout:collectionViewLayout];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 5: {
            UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
            AF25ViewController *viewController = [[AF25ViewController alloc] initWithCollectionViewLayout:collectionViewLayout];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 6: {
            UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
            AF26ViewController *viewController = [[AF26ViewController alloc] initWithCollectionViewLayout:collectionViewLayout];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 7: {
            
            break;
        }
        default:
            break;
    }
}

@end
