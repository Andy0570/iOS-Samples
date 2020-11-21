//
//  SecondViewController.m
//  CodeDemo
//
//  Created by wangrui on 2017/4/11.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import "SecondViewController.h"

#import "WRNavigationBar.h"

// offsetY > -64 的时候导航栏开始偏移
#define NAVBAR_TRANSLATION_POINT 0
#define NavBarHeight 44

@interface SecondViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation SecondViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"浮动效果";
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.imgView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    
    // !!!: 退出视图时，显示回导航栏
    [self setNavigationBarTransformProgress:0];
}


#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        // !!!: 设置列表视图向上偏移的距离
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


#pragma mark - UIScrollViewDelegate

// !!!: 通过计算滚动视图的偏移量，隐藏或者显示导航栏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Y 方向上的偏移量，默认值为 -24
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 默认值 -24，手指向上滑动变正，手指向下滑动变负
    // 如果 Y 轴方向的偏移量超过 > 0，隐藏导航栏
    if (offsetY > NAVBAR_TRANSLATION_POINT) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarTransformProgress:1];            
        }];
    } else {
        // 否则显示导航栏
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarTransformProgress:0];
        }];
    }
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress {
    // 设置导航栏在垂直方向上偏移的距离
    // -44 * progress
    [self.navigationController.navigationBar wr_setTranslationY:(-NavBarHeight * progress)];
    
    // 设置导航栏所有 BarButtonItem 的透明度，隐藏时透明度为 0，显示时透明度为 1.
    // 有系统的返回按钮，所以 hasSystemBackIndicator = YES
    [self.navigationController.navigationBar wr_setBarButtonItemsAlpha:(1 - progress)
                                                hasSystemBackIndicator:YES];
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
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    NSString *str = [NSString stringWithFormat:@"WRNavigationBar %zd",indexPath.row];
    vc.title = str;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
