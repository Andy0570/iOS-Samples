//
//  HQLMainViewController.m
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMainViewController.h"

// Frameworks
#import <Chameleon.h>
#import <JKCategories.h>
#import <Masonry.h>
#import "UIView+Toast.h"
#import <PYSearch.h>

// Controllers
#import "HQLNextViewController.h"

@interface HQLMainViewController ()

@end

@implementation HQLMainViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor flatWhiteColor];
        
    [self setupNavigationBar];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Private

- (void)setupNavigationBar {
    
    self.navigationItem.title = nil;
    
    // 隐藏导航栏底部线条，Chameleon 方法
    self.navigationController.hidesNavigationBarHairline = YES;
    
    
    // 「定位」按钮
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setTitle:@"无锡" forState:UIControlStateNormal];
    [locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 15*15
    [locationButton setImage:[UIImage imageNamed:@"nav_dingwei"]
                    forState:UIControlStateNormal];
    locationButton.adjustsImageWhenHighlighted = NO;
    [locationButton jk_setImagePosition:LXMImagePositionLeft spacing:0];
    [locationButton addTarget:self action:@selector(navigationlocationButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationButton];
    
    
    // 「搜索」按钮    
    // 自定义搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 190, 32);
    searchButton.layer.cornerRadius = 16;
    searchButton.layer.masksToBounds = YES;
    searchButton.backgroundColor = [UIColor whiteColor];
    // 标题
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    // 图片，18*18
    [searchButton setImage:[UIImage imageNamed:@"nav_sousuo"] forState:UIControlStateNormal];
    searchButton.adjustsImageWhenHighlighted = NO;
    // 设置图片、标题左对齐
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 图片向右移动 10pt
    searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10.0f, 0, 0);
    // 标题向右移动 20pt
    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15.0f, 0, 0);
    [searchButton addTarget:self action:@selector(navigationSearchButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;
    
    
    // 「购物袋」按钮
    UIBarButtonItem *shoppingBagButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_gouwudai"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationShoppingBagButtonDidClicked:)];
    
    
    // 「扫一扫」按钮
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_saoyisao"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationScanButtonDidClicked:)];
    self.navigationItem.rightBarButtonItems = @[scanButton, shoppingBagButton];
    
    // 自动布局，调整搜索框
//    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(locationButton.mas_right).with.offset(15);
//        make.centerX.mas_equalTo(self.navigationController.navigationBar.mas_centerX);
//        make.width.mas_equalTo(@200);
//    }];
    
}





#pragma mark - IBActions

- (void)navigationlocationButtonDidClicked:(id)sender {
    
    // 1. 创建热门搜索数组
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];

    // 2. 创建搜索视图控制器 searchViewController
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入搜索内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Call this Block when completion search automatically
        // Such as: Push to a view controller
        // 当搜索完成后调用此处的 Block
        [searchViewController.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];

    }];
    // 设置热门搜索样式
    searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag;
    // 搜索历史样式
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    // 设置搜索结果显示模式
    searchViewController.searchResultShowMode = PYSearchResultShowModeEmbed;
    
    // 3. present the searchViewController
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
//    [self presentViewController:nav  animated:NO completion:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
    
}

- (void)navigationSearchButtonDidClicked:(id)sender {
    [self.view makeToast:@"你点击了搜索按钮"];
    
}

- (void)navigationShoppingBagButtonDidClicked:(id)sender {
    [self.view makeToast:@"购物袋按钮被点击了！"];
}

- (void)navigationScanButtonDidClicked:(id)sender {
    
    // 这里随便拿一个视图控制器做测试
    HQLNextViewController *vc = [[HQLNextViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
