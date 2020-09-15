//
//  HQLMainViewController.m
//  CodeDemo
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 wangrui. All rights reserved.
//

#import "HQLMainViewController.h"
#import "HQLMainViewController+NavigationBar.h"

// Frameworks
//#import "WRNavigationBar.h"
//#import "WRCustomNavigationBar.h"

@interface HQLMainViewController ()

//@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

@end

@implementation HQLMainViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
    
    [self hql_setupNavigationBar];
    
    // self.navigationController.navigationBar.hidden = YES;
    // self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - Custom Accessors

//- (WRCustomNavigationBar *)customNavBar {
//    if (!_customNavBar) {
//        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
//        [_customNavBar wr_setTintColor:[UIColor whiteColor]];
//        [_customNavBar wr_setBottomLineHidden:YES];
//    }
//    return _customNavBar;
//}

#pragma mark - Private

@end
