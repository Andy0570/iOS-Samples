//
//  AFAppDelegate.m
//  Chapter 2 Project 2
//
//  Created by Ash Furrow on 2012-12-10.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFAppDelegate.h"

#import "AFViewController.h"

@implementation AFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 初始化集合视图布局
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    collectionViewLayout.itemSize = CGSizeMake(20, 50);
    self.window.rootViewController = [[AFViewController alloc] initWithCollectionViewLayout:collectionViewLayout];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
