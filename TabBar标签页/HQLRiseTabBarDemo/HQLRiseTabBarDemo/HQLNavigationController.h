//
//  HQLNavigationController.h
//  HQLRiseTabBarDemo
//
//  Created by Qilin Hu on 2019/10/14.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLNavigationController : UINavigationController

/*
 删除导航栏底部线条
 
 推荐替代方法：位于 ChameleonDemo：该方法会把所有页面的底部线条删除
 self.navigationController.hidesNavigationBarHairline = YES;
 */
- (void)removeUnderline;

@end

NS_ASSUME_NONNULL_END
