//
//  HQLMeDemo1TableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/23.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLMeDemo1TableViewController.h"

// Framework
#import <Toast.h>

// View
#import "HQLMeHeaderView.h"

// Model
#import "HQLTableViewGroupedModel.h"

// Delegate
#import "HQLGroupedArrayDataSource.h"

// Category
#import "UITableViewCell+ConfigureModel.h"

// Store
#import "HQLPropertyListStore.h"

// 判断是否为刘海屏
#define IS_NOTCH_SCREEN \
([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) \
&& (([[UIScreen mainScreen] bounds].size.height == 812.0f) \
|| ([[UIScreen mainScreen] bounds].size.height == 896.0f))

// cell 重用标识符
static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface HQLMeDemo1TableViewController ()

@property (nonatomic, strong) NSArray *groupedModelsArray;
@property (nonatomic, strong) HQLGroupedArrayDataSource *arrayDataSource;
@property (nonatomic, assign) CGFloat defaultOffSetY; // 初始默认偏移量，即默认导航栏+状态栏高度
@property (nonatomic, strong) HQLMeHeaderView *headerView;

@end

@implementation HQLMeDemo1TableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    [self setupTableView];
}

#pragma mark - Custom Accessors

// 从 mineDemo1TableViewDataSource.plist 文件中读取数据源加载到 NSArray 类型的数组中
- (NSArray *)groupedModelsArray {
    if (!_groupedModelsArray) {
        HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithPlistFileName:@"mineDemo1TableViewDataSource.plist" modelsOfClass:HQLTableViewGroupedModel.class];
        _groupedModelsArray = store.dataSourceArray;
    }
    return _groupedModelsArray;
}

- (CGFloat)defaultOffSetY {
    if (!_defaultOffSetY) {
        _defaultOffSetY = IS_NOTCH_SCREEN ? 88 : 64;
    }
    return _defaultOffSetY;
}

- (HQLMeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HQLMeHeaderView alloc] initWithFrame:CGRectZero];
    }
    return _headerView;
}

#pragma mark - Private

- (void)setupTableView {
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
        
    // 配置 tableView 数据源
    HQLTableViewCellConfigureBlock configureBlock = ^(UITableViewCell *cell, HQLTableViewModel *model) {
        [cell hql_configureForModel:model];
    };
    self.arrayDataSource = [[HQLGroupedArrayDataSource alloc] initWithGroups:self.groupedModelsArray cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureBlock];
    self.tableView.dataSource = self.arrayDataSource;
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    // 隐藏 tableView 底部空白部分线条
    self.tableView.tableFooterView = [UIView new];
    // 设置表头视图
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *string = [NSString stringWithFormat:@"section = %ld, row = %ld",(long)indexPath.section,(long)indexPath.row];
    [self.view makeToast:string duration:3.0f position:CSToastPositionCenter];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

// ----------------------------------------
//    // Y 方向上的偏移量，默认值为 0，上滑为正，下拉为负
//    CGFloat offsetY = scrollView.contentOffset.y;
//
//    if (offsetY > 0) {
//        CGFloat alpha = offsetY / self.defaultOffSetY;
//        // [self wr_setNavBarBackgroundAlpha:alpha];
//        // 当导航栏变化到一半的时候，达到临界值，调整字体颜色
//        if (alpha > 0.5) {
//            // 黑色标题，白色背景
//            // [self wr_setNavBarTintColor:[UIColor blackColor]];
//            // [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
//            // [self wr_setNavBarTitleColor:[UIColor blackColor]];
//            // self.title = self.brandModel.name;
//
//            // [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        } else {
//            // [self setDefaultNavBarStyle];
//        }
//    } else {
//        // [self setDefaultNavBarStyle];
//    }
//
//    // 限制下拉的距离 0
//    if(offsetY < 0) {
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//    }

// --------------------------------------
//    // 添加下拉手势，图片放大效果
//    CGFloat imageHeight = 165;
//    CGFloat imageWidth = kScreenWidth;
//    // 图片上下偏移量
//    CGFloat imageOffsetY = scrollView.contentOffset.y;
//    
//
//    
//    if (imageOffsetY < 0) {
//        // 放大倍率 = （图片高度 + 偏移量） / 图片高度
//        CGFloat totalOffSet = imageHeight + ABS(imageOffsetY);
//        CGFloat scale = totalOffSet / imageHeight;
//        self.headerView.frame = CGRectMake(-(imageWidth * scale - imageWidth) * 0.5, imageOffsetY, imageWidth * scale, totalOffSet);
//    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    [self.headerView updateHeaderImageViewFrameWithOffsetY:offsetY];
}

@end
