//
//  Example3ViewController.m
//  UIScrollView
//
//  Created by Qilin Hu on 2020/12/7.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "Example3ViewController.h"

// pageControl 的高度
static const CGFloat kPageControlHeight = 70.0f;

@interface Example3ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation Example3ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化数组，元素名称即为图片名称
    self.contentList = @[@"one",@"two",@"three",@"four",@"five",@"six"];
    
    // 2.将 scrollView 和 pageControl 添加到 view 上
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    // 3.为 scrollView 每一页添加图片
    [self.contentList enumerateObjectsUsingBlock:^(NSString *imgName, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        CGFloat height = CGRectGetHeight(self.scrollView.frame);
        CGFloat originX = width * idx;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 0, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:imgName];
        [self.scrollView addSubview:imageView];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Custom Accessors

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPageControlHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 2*kPageControlHeight)];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * self.contentList.count, CGRectGetHeight(self.view.frame) - 2*kPageControlHeight);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - kPageControlHeight, CGRectGetWidth(self.view.frame), kPageControlHeight)];
        _pageControl.numberOfPages = self.contentList.count;
        _pageControl.currentPage = 0;
        
        [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

#pragma mark - Actions

- (void)changePage:(id)sender {
    NSUInteger page = self.pageControl.currentPage;
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = self.scrollView.frame.origin.y;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

#pragma mark - UIScrollViewDelegate

// 该方法在「已经结束减速时」调用
// 仅当停止拖拽后继续移动时才会被调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 根据当前位置计算当前视图所处的页数
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    // floor() 取不大于传入值的最大整数
    // 开启分页后，scrollView 的偏移坐标 x 只有在超过了该页的中点后，才会进入新的一页，否则将会停留在上一页。
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    self.pageControl.currentPage = page;
}

@end
