//
//  MYPresentationController.h
//  上拉,下拉菜单
//
//  Created by 孟遥 on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPresentedController.h"

@interface MYPresentationController : UIPresentationController

@property (nonatomic, assign) MYPresentedViewShowStyle style;
@property (nonatomic, assign,getter=isNeedClearBack) BOOL clearBack;
//frame
@property (assign, nonatomic) CGRect showFrame;
@end
