//
//  YPGradientDemoViewController.m
//  YPNavigationBarTransition-Example
//
//  Created by Li Guoyin on 2017/12/30.
//  Copyright © 2017年 yiplee. All rights reserved.
//

#import "YPGradientDemoViewController.h"
#import <HBDNavigationBar/UIViewController+HBD.h>
#import "DemoViewController.h"

@interface YPGradientDemoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YPGradientDemoViewController {
    CGFloat _gradientProgress; // 渐变进度值
}

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view = tableView;
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"Dynamic Gradient Bar";
    
    UITableView *tableView = self.tableView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"lakeside_sunset" ofType:@"png"];
    UIImage *headerImage = [UIImage imageWithContentsOfFile:imagePath];
    _headerView = [[UIImageView alloc] initWithImage:headerImage];
    _headerView.clipsToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_headerView aboveSubview:tableView];
    
    // !!!: 重置导航栏样式
    self.hbd_barAlpha = 0.0;
    self.hbd_barStyle = UIBarStyleBlack;
    self.hbd_tintColor = UIColor.whiteColor;
    self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor.whiteColor colorWithAlphaComponent:0.0] };
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UITableView *tableView = self.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    CGRect headerFrame = headerView.frame;
    
    // tableView 列表下移，腾出 headerImage 空间
    if (tableView.contentInset.top == 0) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        if (@available(iOS 11,*)) {
            inset.bottom = self.view.safeAreaInsets.bottom;
        }
        tableView.scrollIndicatorInsets = inset;
        inset.top = imageHeight;
        tableView.contentInset = inset;
        tableView.contentOffset = CGPointMake(0, -inset.top);
    }
    
    // 如果 headerImage 的高度与图片默认高度不符，则更新 frame
    if (CGRectGetHeight(headerFrame) != imageHeight) {
        headerView.frame = [self headerImageFrame];
    }
}

- (CGRect) headerImageFrame {
    UITableView *tableView = self.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    
    // 默认值 -0.083333
    CGFloat contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    if (contentOffsetY < 0) {
        // MARK: 从上往下滑（下拉操作，放大图片，更新图片的高度值）
        imageHeight += -contentOffsetY;
    }
    
    CGRect headerFrame = self.view.bounds;
    if (contentOffsetY > 0) {
        // MARK: 从下往上滑（上滑操作，隐藏图片，上移图片的 origin.y 值）
        headerFrame.origin.y -= contentOffsetY;
    }
    headerFrame.size.height = imageHeight;
    
    return headerFrame;
}

- (void) popToRoot:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"demo"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 16;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"click me";
    return cell;
}

#pragma mark - <UIScrollViewDelegate>

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat headerHeight = CGRectGetHeight(self.headerView.frame);
    
    if (@available(iOS 11,*)) {
        headerHeight -= self.view.safeAreaInsets.top;
    } else {
        headerHeight -= [self.topLayoutGuide length];
    }
    
    // 更新导航栏背景透明度
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    // 确保值在 0～1 之间
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        if (_gradientProgress < 0.1) {
            self.hbd_barStyle = UIBarStyleBlack;
            self.hbd_tintColor = UIColor.whiteColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:0] };
        } else {
            self.hbd_barStyle = UIBarStyleDefault;
            self.hbd_tintColor = UIColor.blackColor;
            self.hbd_titleTextAttributes = @{ NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:_gradientProgress] };
        }
        
        self.hbd_barAlpha = _gradientProgress;
        [self hbd_setNeedsUpdateNavigationBar];
    }
    self.headerView.frame = [self headerImageFrame];
}

@end
