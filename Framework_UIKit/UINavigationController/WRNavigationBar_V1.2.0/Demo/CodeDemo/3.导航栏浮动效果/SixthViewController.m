//
//  SixthViewController.m
//  CodeDemo
//
//  Created by wangrui on 2017/4/14.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import "SixthViewController.h"

#import "WRNavigationBar.h"

// offsetY > -64 的时候导航栏开始偏移
#define NAVBAR_TRANSLATION_POINT 0
#define NavBarHeight 44

@interface SixthViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation SixthViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"自定义导航栏";
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.imgView;
    
    // MARK: 自定义导航栏
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我要返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonDidClicked:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    
    // !!!: 退出视图时，显示回导航栏
    [self setNavigationBarTransformProgress:0];
}


#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image2"]];
    }
    return _imgView;
}


#pragma mark - IBActions

- (void)backBarButtonDidClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Y 方向上的偏移量，默认值为 -24
    CGFloat offsetY = scrollView.contentOffset.y;
    // 向上滑动的距离
    // 默认值 -24，手指向上滑动变正，手指向下滑动变负
    CGFloat scrollUpHeight = offsetY - NAVBAR_TRANSLATION_POINT;
    // 取整运算符 -> 导航栏从完全不透明到完全透明的过渡距离 5/44
    CGFloat progress = scrollUpHeight / NavBarHeight;
    if (offsetY > NAVBAR_TRANSLATION_POINT) {
        if (scrollUpHeight > 44) {
            // 如果向上滑动超过 44，则直接隐藏导航栏
            [self setNavigationBarTransformProgress:1];
        } else {
            // 否则慢慢隐藏导航栏
            [self setNavigationBarTransformProgress: progress];
        }
    } else {
        [self setNavigationBarTransformProgress:0];
    }
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress {
    [self.navigationController.navigationBar wr_setTranslationY:(-NavBarHeight * progress)];
    
    // 设置导航栏所有 BarButtonItem 的透明度
    // 没有系统返回按钮，所以 hasSystemBackIndicator = NO
    // 如果这里不设置为NO，你会发现，导航栏无缘无故多出来一个返回按钮
    [self.navigationController.navigationBar wr_setBarButtonItemsAlpha:(1 - progress)
                                                hasSystemBackIndicator:NO];
    // MARK: 设置整个导航栏透明度的跟随渐变效果
    // [self wr_setNavBarBackgroundAlpha:(1-progress)];
}


#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    NSString *str = [NSString stringWithFormat:@"WRNavigationBar %zd",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
