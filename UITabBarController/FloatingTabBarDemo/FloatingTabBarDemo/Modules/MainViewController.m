//
//  MainViewController.m
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "HQLFloatingTabBarManager.h"

@interface MainViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MainViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:255/255.0 alpha:1.0];
    
    [self addScrollView];
    [self addImageView];
}

- (void)addScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    CGRect bigRect = self.view.frame;
    bigRect.size.height *= 2.0;
    _scrollView.contentSize = bigRect.size;
    [self.view addSubview:self.scrollView];
}

- (void)addImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"yoona.jpg"];
    [self.scrollView addSubview:imageView];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint velocityPoint = [scrollView.panGestureRecognizer velocityInView:scrollView];
    if (velocityPoint.y < -5) {
        // 手指从下往上滑，浏览更多内容，收起悬浮按钮
        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] compressFloatingTabBar];
    } else if (velocityPoint.y > 5) {
        // 手指从上往下滑，返回顶部，还原悬浮按钮
        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] stretchFloatingTabBar];
    }
}

// 该方法在「用户停止拖拽时」调用
// decelerate（减速） 为 NO，表示 scrollView 滑动是立即停止的。
// decelerate（减速） 为 YES，表示手指停止拖拽后 scrollView 还在自动继续减速（动画缓慢停止）。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    [self delayStretchFloatingTabBar];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self delayStretchFloatingTabBar];
}

// 该方法在 scrollView 已经滑动到顶部时调用
// 仅当通过点击状态栏让 scrollView 滑动到顶部才调用
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    // 滑动到顶部时，还原悬浮框
    [[HQLFloatingTabBarManager sharedFloatingTabBarManager] stretchFloatingTabBar];
}

- (void)delayStretchFloatingTabBar {
    double delayInSeconds = 2.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 停止滑动 3s 后，还原悬浮框
        [[HQLFloatingTabBarManager sharedFloatingTabBarManager] stretchFloatingTabBar];
    });
}

@end
