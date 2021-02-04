//
//  PENaviTransition.h
//  PETransition
//
//  Created by Petry on 16/9/11.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PENaviTransitionType){
    PENaviTransitionTypePush = 0,
    PENaviTransitionTypePop
};

@interface PENaviTransition : NSObject<UIViewControllerAnimatedTransitioning>


+ (instancetype)transitionWithType:(PENaviTransitionType)type;
- (instancetype)initWithTransitionType:(PENaviTransitionType)type;

@end
