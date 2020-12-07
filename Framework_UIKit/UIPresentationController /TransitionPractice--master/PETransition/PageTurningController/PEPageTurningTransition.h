//
//  PEPageTurningTransition.h
//  PETransition
//
//  Created by Petry on 16/9/14.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PEPageTurningTransitionType) {
    PEPageTurningTransitionTypePush = 0,
    PEPageTurningTransitionTypePop
};


@interface PEPageTurningTransition : NSObject<UIViewControllerAnimatedTransitioning>

/** 存储过渡动画的类型 */
@property (nonatomic, assign)PEPageTurningTransitionType type;

//初始化动画方法
+ (instancetype)transitionWithType:(PEPageTurningTransitionType)type;
- (instancetype)initWithTransitionType:(PEPageTurningTransitionType)type;

@end
