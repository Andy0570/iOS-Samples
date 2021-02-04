//
//  Example1ViewController.m
//  UIScrollView
//
//  Created by Qilin Hu on 2020/12/7.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "Example1ViewController.h"

@interface Example1ViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation Example1ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - Custom Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"Image"];
        _imageView = [[UIImageView alloc] initWithImage:image];
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        // contentSize 用来标识 UIScrollView 的可滚动范围
        _scrollView.contentSize = self.imageView.frame.size;
        // 在屏幕旋转时，让 scrollView 自动调整布局
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _scrollView;
}

@end
