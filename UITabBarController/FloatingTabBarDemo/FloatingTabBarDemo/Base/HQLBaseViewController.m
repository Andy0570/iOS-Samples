//
//  HQLBaseViewController.m
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/14.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBaseViewController.h"

@interface HQLBaseViewController ()

@end

@implementation HQLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *randomColor = [UIColor colorWithDisplayP3Red:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    self.view.backgroundColor = randomColor;
}

#pragma mark - <JXCategoryListContentViewDelegate>

- (UIView *)listView {
    return self.view;
}

/**
 可选实现，列表将要显示的时候调用
 */
- (void)listWillAppear {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/**
 可选实现，列表将要消失的时候调用
 */
- (void)listWillDisappear {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

@end
