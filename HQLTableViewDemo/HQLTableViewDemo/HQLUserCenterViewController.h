//
//  HQLUserCenterViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/13.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HQLUser;

/// 用户中心页面示例
@interface HQLUserCenterViewController : UIViewController

@property (nonatomic, strong) HQLUser *user;

@end

NS_ASSUME_NONNULL_END
