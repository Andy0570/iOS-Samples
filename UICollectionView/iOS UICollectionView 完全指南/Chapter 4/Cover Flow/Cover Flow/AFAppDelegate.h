//
//  AFAppDelegate.h
//  Cover Flow
//
//  Created by Ash Furrow on 2013-01-13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFViewController;

/// !!!: 封面流式布局，参考 <https://github.com/mpospese/IntroducingCollectionViews>
@interface AFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *viewController;

@end
