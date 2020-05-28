//
//  HQLPayResultViewController.h
//  Demo
//
//  Created by Qilin Hu on 2020/5/22.
//  Copyright © Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

// Model
#import "HQLPayResultModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 支付结果显示页面
@interface HQLPayResultViewController : UIViewController

- (instancetype)initWithPayResult:(HQLPayResultModel *)resultModel;

@end

NS_ASSUME_NONNULL_END
