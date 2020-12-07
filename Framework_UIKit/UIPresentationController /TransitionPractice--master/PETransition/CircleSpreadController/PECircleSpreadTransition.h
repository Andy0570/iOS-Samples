//
//  PECircleSpreadTransition.h
//  PETransition
//
//  Created by Petry on 16/9/17.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PECircleSpreadTransitionType) {
    PECircleSpreadTransitionTypePresent = 0,
    PECircleSpreadTransitionTypeDismiss
};

@interface PECircleSpreadTransition : NSObject<UIViewControllerAnimatedTransitioning>

/** 类型 */
@property (nonatomic, assign)PECircleSpreadTransitionType type;

+ (instancetype)transitionWithTransitionType:(PECircleSpreadTransitionType)type;
- (instancetype)initWithTransitionType:(PECircleSpreadTransitionType)type;

@end
