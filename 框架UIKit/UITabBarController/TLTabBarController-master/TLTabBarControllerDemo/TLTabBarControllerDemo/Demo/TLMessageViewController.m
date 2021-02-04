//
//  TLMessageViewController.m
//  TLTabBarControllerDemo
//
//  Created by 李伯坤 on 2017/11/6.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "TLMessageViewController.h"
#import "TLTabBarControllerProtocol.h"
#import "SVProgressHUD.h"

@interface TLMessageViewController () <TLTabBarControllerProtocol>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation TLMessageViewController

- (void)loadView {
    [super loadView];
    [self setTitle:@"消息"];
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    UIBarButtonItem *clearBadgeButton = [[UIBarButtonItem alloc] initWithTitle:@"消除红点" style:UIBarButtonItemStylePlain target:self action:@selector(clearBadgeButtonClick)];
    [self.navigationItem setRightBarButtonItem:clearBadgeButton];
    
    [self loadRequest];
}

- (void)clearBadgeButtonClick
{
    [self.tabBarItem setBadgeValue:nil];
}

- (void)loadRequest
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.libokun.com"]]];
}

#pragma mark - # TLTabBarControllerProtocol
- (void)tabBarItemDidDoubleClick
{
    [SVProgressHUD showInfoWithStatus:@"正在刷新..."];
    [self loadRequest];
}

@end
