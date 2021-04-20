//
//  HQLCoordinatorViewController+EAIntroView.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/8/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCoordinatorViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQLCoordinatorViewController (EAIntroView)

// 通过 EAIntroView 框架显示启动引导页；
- (void)hql_showIntroWithCrossDissolve;

@end

NS_ASSUME_NONNULL_END
