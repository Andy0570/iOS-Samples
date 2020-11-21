//
//  SecondViewController.m
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "SecondViewController.h"
#import <JXCategoryView/JXCategoryTitleView.h>
#import <Chameleon.h>

@interface SecondViewController ()
@property (nonatomic, strong) JXCategoryTitleView *categoryTitleView;
@end

@implementation SecondViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"去逛街";
    [self setupCategoryView];
}

- (void)setupCategoryView {
    self.titles = @[@"推荐",@"宝贝",@"新品",@"聚划算",@"好物",@"买家秀",@"买家推荐"];
    self.categoryTitleView.titles = self.titles;
    self.categoryTitleView.titleColorGradientEnabled = YES;
    self.categoryTitleView.titleColor = rgb(156, 156, 156);
    self.categoryTitleView.titleSelectedColor = rgb(84, 202, 195);
    self.categoryTitleView.titleLabelZoomEnabled = YES;
    self.categoryTitleView.titleLabelStrokeWidthEnabled = YES;
    self.categoryTitleView.selectedAnimationEnabled = YES;
    
    // 添加指示器
//    JXCategoryIndicatorLineView *categoryIndicatorLineView = [[JXCategoryIndicatorLineView alloc] init];
//    categoryIndicatorLineView.indicatorWidth = 41.0f;
//    categoryIndicatorLineView.lineStyle = JXCategoryIndicatorLineStyle_LengthenOffset;
//    categoryIndicatorLineView.indicatorColor = rgb(84, 202, 195);
//    self.categoryTitleView.indicators = @[categoryIndicatorLineView];
}

#pragma mark - Custom Accessors

- (JXCategoryTitleView *)categoryTitleView {
    return (JXCategoryTitleView *)self.categoryBaseView;
}

#pragma mark - Override

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

@end
