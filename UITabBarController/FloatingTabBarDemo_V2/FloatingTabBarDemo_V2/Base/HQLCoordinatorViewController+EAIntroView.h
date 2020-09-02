//
//  HQLCoordinatorViewController+EAIntroView.h
//  FloatingTabBarDemo_V2
//
//  Created by Qilin Hu on 2020/9/1.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCoordinatorViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 通过 Category 类集成第三方功能，实现功能模块相互解耦合
 
 集成 EAIntroView 框架，显示启动引导页；
 */
@interface HQLCoordinatorViewController (EAIntroView)

// 通过 EAIntroView 框架显示启动引导页；
- (void)hql_showIntroWithCrossDissolve;

@end

NS_ASSUME_NONNULL_END
