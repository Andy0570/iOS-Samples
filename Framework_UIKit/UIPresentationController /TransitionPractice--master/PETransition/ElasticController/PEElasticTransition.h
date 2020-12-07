//
//  PEElasticTransition.h
//  PETransition
//
//  Created by Petry on 16/9/13.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PEElasticTransitionType) {
    PEElasticTransitionTypePresent = 0,
    PEElasticTransitionTypeDismiss
};

@interface PEElasticTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(PEElasticTransitionType)type;

- (instancetype)initWithTransitionType:(PEElasticTransitionType)type;

@end
