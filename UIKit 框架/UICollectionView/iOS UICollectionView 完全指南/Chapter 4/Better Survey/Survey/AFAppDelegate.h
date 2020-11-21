//
//  AFAppDelegate.h
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFViewController;

/// !!!: 自定义 UICollectionViewFlowLayout 子类布局对象，在页面中均匀布局单元格
@interface AFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AFViewController *viewController;

@end
