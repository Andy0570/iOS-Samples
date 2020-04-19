//
//  PageViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/4/16.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "PageViewController.h"

// Framework
#import <YYKit.h>

// Controller
#import "FirstSubViewController.h"
#import "SecondSubViewController.h"


@interface PageViewController () <UIScrollViewDelegate>

// 滚动视图，作为容器视图
@property (nonatomic, strong) UIScrollView *scrollerView;
@property (nonatomic, strong) FirstSubViewController *firstVC;
@property (nonatomic, strong) SecondSubViewController *secondVC;

// 控制翻页的属性，使用它来控制滚动视图的翻页。通过该组件中的小白点，来观察当前页面的位置
@property (nonatomic, strong) UIPageControl *pageControl;

// 状态属性，用来标志页面拖动状态
@property (nonatomic, assign) BOOL isPageControlUsed;

@end

@implementation PageViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加容器视图
    [self.view addSubview:self.scrollerView];
    // 添加页面控制小圆点
    [self.view addSubview:self.pageControl];
    
    // 首先获取当前屏幕的尺寸
    CGRect screenFrame = [[UIScreen mainScreen] bounds];

    // 创建第一个视图控制器对象的实例
    _firstVC = [[FirstSubViewController alloc] init];
    // 设置坐标原点的纵向值为0
    screenFrame.origin.y = 0;
    // 设置第一个视图控制器对象的显示区域
    _firstVC.view.frame = screenFrame;
    
    // 创建第二个视图控制器对象的实例
    _secondVC = [[SecondSubViewController alloc] init];
    // 设置坐标原点的X值为屏幕宽度，即第二个视图控制器对象显示在屏幕之外(右侧)
    screenFrame.origin.x = screenFrame.size.width;
    // 设置第二个视图控制器对象的显示区域
    _secondVC.view.frame = screenFrame;
    
    // 将两个视图添加到滚动视图对象里
    [self.scrollerView addSubview:_firstVC.view];
    [self.scrollerView addSubview:_secondVC.view];
}


#pragma mark - Custom Accessors

- (UIScrollView *)scrollerView {
    if (!_scrollerView) {
        // 初始化滚动视图对象，并设置滚动视图的尺寸信息
        _scrollerView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // 设置滚动视图为分页模式，即每滚动一次就是一页
        _scrollerView.pagingEnabled = YES;
        // 我们有两个页面，所以将滚动视图的“取景范围”的宽度，设置为两倍页面宽度
        _scrollerView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight);
        // 设置滚动视图的背景色为白色
        _scrollerView.backgroundColor = [UIColor whiteColor];
        // 设置滚动视图对象的代理为当前类，这样就可以在当前文件中，编写代理方法，以捕捉滚动视图的相关动作
        _scrollerView.delegate = self;
    }
    return _scrollerView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        // 创建一个区域，显示页面控制器对象
        int pcHeight = 50;
        // 设置页面控制器对象的显示区域
        CGRect rect = CGRectMake(0, kScreenHeight - pcHeight * 2, kScreenWidth, pcHeight);
        
        // 初始化页面控制器对象
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        // 设置总页数
        _pageControl.numberOfPages = 2;
        // 设置当前页编号
        _pageControl.currentPage = 0;
        // 设置页面控制器对象的背景颜色为透明色
        _pageControl.backgroundColor = [UIColor clearColor];
        // 给页面控制器对象，添加监听页面切换事件的方法
        [_pageControl addTarget:self
                         action:@selector(pageControlDidChanged:)
                    forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}


#pragma mark - IBActions

// 创建监听页面切换事件的方法
- (void)pageControlDidChanged:(id)sender {
    // 获得当前页面控制器对象的显示页码
    NSInteger currentPage = self.pageControl.currentPage;
    // 获得滚动视图当前显示区域
    CGRect frame = self.scrollerView.frame;
    // 根据页面控制器对象的当前页码，计算滚动视图在下一页的显示区域
    frame.origin.x = frame.size.width * currentPage;
    frame.origin.y = 0;
    
    // 滚动视图到目标位置
    [self.scrollerView scrollRectToVisible:frame animated:YES];
    // 设置通过页面控制器对象切换页面
    _isPageControlUsed = YES;
}


#pragma mark - UIScrollViewDelegate

// 创建监听滚动视图的滚动事件的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 如果是通过【页面控制器对象切换】，则不执行后面的代码
    if (_isPageControlUsed) {
        return;
    }
    
    // 如果是【手指滑动切换】，要同步当前视图所对应的页面控制器页码值
    // 获得滚动视图的宽度值
    CGFloat pageWidth = self.scrollerView.frame.size.width;
    // 根据滚动视图的宽度值和横向位移量，计算当前页码
    // floor() 向下取整，得出 0 或者 1
    int page = floor((self.scrollerView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    // 设置页面控制器的显示页码，为通过计算所得的页码
    self.pageControl.currentPage = page;
}

// 创建监听滚动视图的滚动减速事件的代理方法。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 重置标识变量的默认值
    _isPageControlUsed = NO;
}

@end
