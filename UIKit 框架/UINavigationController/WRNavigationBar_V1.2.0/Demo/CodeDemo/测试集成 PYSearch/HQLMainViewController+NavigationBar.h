//
//  HQLMainViewController+NavigationBar.h
//  CodeDemo
//
//  Created by Qilin Hu on 2020/9/14.
//  Copyright © 2020 wangrui. All rights reserved.
//

#import "HQLMainViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 !!!: 无法与 PYSearch 很好地配合，有时候搜索框是白色，搜索框显示颜色不稳定！
 */
@interface HQLMainViewController (NavigationBar)

- (void)hql_setupNavigationBar;

@end

NS_ASSUME_NONNULL_END
