//
//  HQLMyStoreCollectionViewController+NavigationBar.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/9/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMyStoreCollectionViewController+NavigationBar.h"
//#import <HBDNavigationBar/UIViewController+HBD.h>

@implementation HQLMyStoreCollectionViewController (NavigationBar)

- (void)hql_defaultNavigationBarStyle {
//    self.hbd_barAlpha = 0.0;
//    self.hbd_barShadowHidden = YES;
//    self.hbd_tintColor = [UIColor whiteColor];
    
    // 设置导航栏背景是否透明
    self.navigationController.navigationBar.translucent = YES;
}

@end
