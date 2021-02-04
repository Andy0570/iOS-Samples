//
//  HQLCategoryBaseViewController.m
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/14.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCategoryBaseViewController.h"
#import "HQLBaseViewController.h"
#import <Masonry.h>

@interface HQLCategoryBaseViewController () <JXCategoryViewDelegate>

@end

@implementation HQLCategoryBaseViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.categoryBaseView.listContainer = self.categoryListContainerView;
    self.categoryBaseView.delegate = self;
    
    [self.view addSubview:self.categoryBaseView];
    [self.categoryBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin);
        make.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo([self preferredCategoryViewHeight]);
    }];
    
    [self.view addSubview:self.categoryListContainerView];
    [self.categoryListContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.categoryBaseView.mas_bottom);
        make.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // 处于第一个 item 的时候，才允许屏幕边缘手势返回
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryBaseView.selectedIndex == 0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // 离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Custom Accessors

- (JXCategoryBaseView *)categoryBaseView {
    if (!_categoryBaseView) {
        _categoryBaseView = [self preferredCategoryView];
    }
    return _categoryBaseView;
}

- (JXCategoryListContainerView *)categoryListContainerView {
    if (!_categoryListContainerView) {
        _categoryListContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _categoryListContainerView;
}

#pragma mark - Public

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryBaseView alloc] init];
}

- (CGFloat)preferredCategoryViewHeight {
    return 44.0f;
}

#pragma mark - <JXCategoryListContainerViewDelegate>

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    HQLBaseViewController *baseVC =  [[HQLBaseViewController alloc] init];
    return baseVC;
}



@end
