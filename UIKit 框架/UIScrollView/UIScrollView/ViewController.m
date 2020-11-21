//
//  ViewController.m
//  UIScrollView
//
//  Created by Qilin Hu on 2020/5/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ViewController


#pragma mark - Controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self setZoomScale];
    
    // 添加双击手势，支持手指双击放大、缩小图像功能
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // 1.移除子视图
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    // 2.初始化 imageView 将其添加到 scrollView 设置 contentSize
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yoona"]];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.frame.size;
    
    // 3.重设 minimumZoomScale
    [self setZoomScale];
}


#pragma mark - Custom Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        // 1080*1350
        UIImage *image = [UIImage imageNamed:@"yoona"];
        // 1.初始化 imageView
        _imageView = [[UIImageView alloc] initWithImage:image];
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        // 2.初始化、配置 scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        // contentSize: 指定滚动视图可以滚动的区域、标识内容区域的尺寸
        _scrollView.contentSize = self.imageView.frame.size;
        
        /**
         设定 scrollView 的 autoresizingMask 为 UIViewAutoresizingFlexibleWidth 和
         UIViewAutoresizingFlexibleHeight，这样在屏幕旋转时，scrollView 就可以自动调整布局。
         */
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        /**
         标识内容区域的起点相对于 scrollView 的起点的偏移量，默认值为 CGPointZero
         */
        _scrollView.contentOffset = CGPointMake(300, 300);
        
        /**
         设置最大最小缩放比
         */
        _scrollView.delegate = self;
//        _scrollView.minimumZoomScale = 0.1; // 最小缩放比例
//        _scrollView.maximumZoomScale = 4.0; // 最大缩放比例
//        _scrollView.zoomScale = 1.0;        // 缩放比例
    }
    return _scrollView;
}


#pragma mark - Private

/**
 让图像在完整显示的前提下，尽可能多的填充 scrollView，即 imageView 使用 UIViewContentModeScaleAspectFit 效果。
 为此，我们将使用滚动视图和图像视图大小的比例来计算最小比例因子 (scale factor)。
 */
- (void)setZoomScale {
    CGFloat widthScale = CGRectGetWidth(self.scrollView.frame) / CGRectGetWidth(self.imageView.frame);
    CGFloat heightScale = CGRectGetHeight(self.scrollView.frame) / CGRectGetHeight(self.imageView.frame);
    
    self.scrollView.minimumZoomScale = MIN(widthScale, heightScale);
}


- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap {
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        // 视图大于最小视图时 双击将视图缩小至最小
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        /*
        // 图像默认以自身的中心为基点进行放大操作
        // 视图为最小时 双击将视图放大至最大
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
        */
        
        // 以点击位置为中心放大图片
        // 1.获取点击位置
        CGPoint touchPoint = [doubleTap locationInView:self.imageView];
        // 2.获取要显示的 imageView 区域
        CGRect zoomRect = [self zoomRectForScrollView:self.scrollView withScale:self.scrollView.maximumZoomScale withCenter:touchPoint];
        // 5.将要显示的imageView区域显示到scrollView
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}


- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(CGFloat)scale withCenter:(CGPoint)center {
    // 3.声明一个区域 滚动视图的宽除以放大倍数可以得到要显示imageView宽度
    CGRect zoomRect;
    zoomRect.size.width = CGRectGetWidth(scrollView.frame) / scale;
    zoomRect.size.height = CGRectGetHeight(scrollView.frame) / scale;
    
    // 4.点击位置x坐标减去1/2图像宽度，可以得到要显示imageView的原点x坐标 y坐标类似
    zoomRect.origin.x = center.x - zoomRect.size.width / 2;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2;
    
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

/**
 支持缩放功能，在该代理方法中返回要缩放的视图
 
 另外，还需要使用 maximumZoomScale 和 minimumZoomScale 指定可应用于滚动视图的最大、最小缩放比。
 这两个属性的默认值均为 1.0。
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

/**
 让图像始终位于屏幕中心
 
 每次缩放操作后，系统都会调用该方法用以告诉滚动视图 zoomScale 已改变。
 我们先计算出图片与屏幕间的填充。对于顶部和底部，先判断 imageView 的高是否小于 scrollView 的高，在 imageView 的高小于 scrollView 的高时，填充高度为两个视图高之差的二分之一，否则，填充为 0；水平方向的填充与此类似。最后设定 scrollView 的 contentInset 属性，该属性用于指定内容视图与滚动视图边缘的距离，单位为 point，默认值为 UIEdgeInsetsZero。
 
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 计算imageView缩小到最小时 imageView 与屏幕边缘距离
    CGFloat horizontalPadding = CGRectGetWidth(self.imageView.frame) < CGRectGetWidth(scrollView.frame) ? (CGRectGetWidth(scrollView.frame) - CGRectGetWidth(self.imageView.frame)) / 2 : 0 ;
    CGFloat verticalPadding = CGRectGetHeight(self.imageView.frame) < CGRectGetHeight(scrollView.frame) ? (CGRectGetHeight(scrollView.frame) - CGRectGetHeight(self.imageView.frame)) / 2 : 0 ;
    scrollView.contentInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding);
}

@end
