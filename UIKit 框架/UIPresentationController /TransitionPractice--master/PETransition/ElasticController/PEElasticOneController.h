//
//  PEElasticOneController.h
//  PETransition
//
//  Created by Petry on 16/9/13.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  PEElasticOneControllerDelegate<NSObject>

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent;
- (void)elasticOneControllerPressDissmiss;

@end

@interface PEElasticOneController : UIViewController

/** 弹出和消失的动画交给代理对象 */
@property (nonatomic, assign)id<PEElasticOneControllerDelegate> delegate;

@end
