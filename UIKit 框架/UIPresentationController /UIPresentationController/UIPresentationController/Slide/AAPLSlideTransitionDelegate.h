//
//  AAPLSlideTransitionDelegate.h
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAPLSlideTransitionDelegate : NSObject <UITabBarControllerDelegate>

//! The UITabBarController instance for which this object is the delegate of.
@property (nonatomic, weak) IBOutlet UITabBarController *tabBarController;

//! The gesture recognizer used for driving the interactive transition
//! between view controllers.  AAPLSlideTransitionDelegate installs this
//! gesture recognizer on the tab bar controller's view.
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecongizer;

@end

NS_ASSUME_NONNULL_END
