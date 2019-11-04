//
//  AppDelegate.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "HQLScaryBugDoc.h"
#import "DetailViewController.h"
#import "HQLScaryBugDatabase.h"

#import <CoreData/CoreData.h> // 使用之前导入 Core Data 框架
#import <YYKit.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

#pragma mark - Custom Accessors

// #1 使用 Lazy Loading 初始化 NSManagedObjectModel 模型对象
- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        // ⚠️ 扩展名为 momd
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Person" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

// #2 使用 Lazy Loading 初始化 NSPersistentStoreCoordinator 协调器对象
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        
        // 传入 Model 对象初始化协调器
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        // 指定 SQLite 数据库文件
        // .documentURL 使用的 YYKit 方法
        NSURL *sqliteURL = [[UIApplication sharedApplication].documentsURL URLByAppendingPathComponent:@"Person.sqlite"];
        
        // 这个 options 是为了进行数据迁移用的，有兴趣的可以研究一下
        NSDictionary *options = @{
                                  NSMigratePersistentStoresAutomaticallyOption:@(YES),
                                  NSInferMappingModelAutomaticallyOption:@(YES),
                                  };
        NSError *error;
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:sqliteURL
                                                        options:options
                                                          error:&error];
        if (error) {
            NSLog(@"创建协调器对象失败：%@",error.localizedDescription);
        }
    }
    return _persistentStoreCoordinator;
}

// 3# 使用 Lazy Loading 初始化 NSManagedObjectContext 上下文对象
- (NSManagedObjectContext *)context {
    if (!_context) {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 指定协调器对象
        _context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _context;
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    // 设置数据源
//    HQLScaryBugDoc *bug1 = [[HQLScaryBugDoc alloc] initWithTitle:@"Potato Bug"
//                                                          rating:4
//                                                      thumbImage:[UIImage imageNamed:@"potatoBugThumb.jpg"]
//                                                       fullImage:[UIImage imageNamed:@"potatoBug.jpg"]];
//    HQLScaryBugDoc *bug2 = [[HQLScaryBugDoc alloc] initWithTitle:@"House Centipede"
//                                                          rating:3
//                                                      thumbImage:[UIImage imageNamed:@"centipedeThumb.jpg"]
//                                                       fullImage:[UIImage imageNamed:@"centipede.jpg"]];
//    HQLScaryBugDoc *bug3 = [[HQLScaryBugDoc alloc] initWithTitle:@"Wolf Spider"
//                                                          rating:5
//                                                      thumbImage:[UIImage imageNamed:@"wolfSpiderThumb.jpg"]
//                                                       fullImage:[UIImage imageNamed:@"wolfSpider.jpg"]];
//    HQLScaryBugDoc *bug4 = [[HQLScaryBugDoc alloc] initWithTitle:@"Lady Bug"
//                                                          rating:1
//                                                      thumbImage:[UIImage imageNamed:@"ladybugThumb.jpg"]
//                                                       fullImage:[UIImage imageNamed:@"ladybug.jpg"]];
//    NSMutableArray *bugs = [NSMutableArray arrayWithObjects:bug1, bug2, bug3, bug4, nil];
    
    NSMutableArray *loadedBugs = [HQLScaryBugDatabase loadScaryBugDocs];
    UINavigationController *navController = [splitViewController.viewControllers firstObject];
    MasterViewController *masterViewController =[navController.viewControllers firstObject];
    masterViewController.bugs = loadedBugs;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
