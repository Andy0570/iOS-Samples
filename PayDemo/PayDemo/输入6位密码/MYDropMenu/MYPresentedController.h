//
//  MYPresentedController.h
//  上拉,下拉菜单
//
//  Created by 孟遥 on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYPresentAnimationManager.h"

typedef void(^handleBack)(id callback);

@interface MYPresentedController : UIViewController

//创建菜单
- (instancetype)initWithShowFrame:(CGRect)showFrame ShowStyle:(MYPresentedViewShowStyle)showStyle callback:(handleBack)callback;
//获取菜单该属性可获知是否展开
@property (nonatomic, assign,getter=isPresented) BOOL presented;
//是否需要显示透明蒙板
@property (nonatomic, assign,getter=isNeedClearBack) BOOL clearBack;
//回调
@property (copy, nonatomic)handleBack callback;

@end
