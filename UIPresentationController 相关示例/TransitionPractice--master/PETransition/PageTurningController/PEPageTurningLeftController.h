//
//  PEPageTurningLeftController.h
//  PETransition
//
//  Created by Petry on 16/9/14.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  PEPageTurningLeftControllerDelegate <NSObject>

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPush;

@end
@interface PEPageTurningLeftController : UIViewController<UINavigationControllerDelegate>

/** push的动画代理对象 */
@property (nonatomic, assign)id<PEPageTurningLeftControllerDelegate> delegate;

@end
