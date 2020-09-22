//
//  AFAppDelegate.h
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFViewController;

/// !!!: 在集合视图中添加长按手势识别器（UILongPressGestureRecognizer）
@interface AFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AFViewController *viewController;

@end
