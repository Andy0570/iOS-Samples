//
//  HQLWebViewController.m
//  HQLNerdfeed
//
//  Created by ToninTech on 16/8/30.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLWebViewController.h"

@implementation HQLWebViewController

- (void) loadView {
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView ;
    
}

- (void) setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

//- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc NS_DEPRECATED_IOS(2_0, 8_0, "Use splitViewController:willChangeToDisplayMode: and displayModeButtonItem instead") __TVOS_PROHIBITED;

- (UIBarButtonItem *)displayModeButtonItem {
    
    //如果某个UIBarButtonItem对象没有标题，该对象就不会有任何显示
//    self.navigationItem.leftBarButtonItem.title = @"Courses";
    
    //将传入的UIBarButtonItem对象设置为navigationItem的左侧按钮
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    return self.navigationItem.leftBarButtonItem;
}

//返回滑动手势的显示模式
- (UISplitViewControllerDisplayMode)targetDisplayModeForActionInSplitViewController:(UISplitViewController *)svc {
    
    //根据设备尺寸和类型自适应
    return UISplitViewControllerDisplayModeAutomatic;
}

//
- (BOOL) splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    return YES;
}


@end
