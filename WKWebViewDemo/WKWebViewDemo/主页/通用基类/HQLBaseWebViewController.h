//
//  HQLBaseWebViewController.h
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/29.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 该视图控制器用于加载 Web 页面
 
 功能特性：
 1. 自动根据 Web 页面返回的 title 标题设置导航栏标题；
 2. 加载进度条指示器；
 */
@interface HQLBaseWebViewController : UIViewController

@property (nonatomic, strong) NSURL *requestURL;

@end

NS_ASSUME_NONNULL_END
