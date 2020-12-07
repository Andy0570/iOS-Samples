//
//  AFAppDelegate.h
//  Cover Flow
//
//  Created by Ash Furrow on 2013-01-13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFViewController;

/// !!!: 在集合视图中添加点击手势识别器（UITapGestureRecognizer）
@interface AFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *viewController;

@end
