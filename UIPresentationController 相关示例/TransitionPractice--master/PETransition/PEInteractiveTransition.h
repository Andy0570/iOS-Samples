//
//  PEInteractiveTransition.h
//  PETransition
//
//  Created by Petry on 16/9/11.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureConfig)();

//手势转场类型
typedef NS_ENUM(NSUInteger,PEInteractiveTransitionType){
    PEInteractiveTransitionTypePresent = 0,
    PEInteractiveTransitionTypeDismiss,
    PEInteractiveTransitionTypePush,
    PEInteractiveTransitionTypePop
};

//手势方向
typedef NS_ENUM(NSUInteger,PEInteractiveTransitionGestureDirection){
    PEInteractiveTransitionGestureDirectionLeft = 0,
    PEInteractiveTransitionGestureDirectionRight,
    PEInteractiveTransitionGestureDirectionUp,
    PEInteractiveTransitionGestureDirectionDown
};

@interface PEInteractiveTransition : UIPercentDrivenInteractiveTransition
/** 记录是否开始手势,判断pop操作是手势出发还是返回键出发 */
@property (nonatomic, assign)BOOL interation;
/** 触发手势present的时候config,在config中初始化并present需要弹出的控制器 */
@property (nonatomic, copy)GestureConfig presentConfig;
/** 触发手势push的时候config,在config中初始化并push需要弹出的控制器 */
@property (nonatomic, copy)GestureConfig pushConfig;

#pragma mark - ---初始化方法---
+ (instancetype)interactiveTransitionWithTransitionType:(PEInteractiveTransitionType)type GestureDirection:(PEInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(PEInteractiveTransitionType)type GestureDirection:(PEInteractiveTransitionGestureDirection)direction;

/** 给传入控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;


@end
