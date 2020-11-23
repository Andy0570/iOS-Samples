//
//  AppDelegate.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/21.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "RWTScaryBugDoc.h"
#import "RWTScaryBugDatabase.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *masterController = navController.viewControllers.firstObject;
    
    // 静态方式设置数据源
//    RWTScaryBugDoc *bug1 = [[RWTScaryBugDoc alloc] initWithTitle:@"Potato Bug" rating:4 thumbImage:[UIImage imageNamed:@"potatoBugThumb.jpg"] fullImage:[UIImage imageNamed:@"potatoBug.jpg"]];
//    RWTScaryBugDoc *bug2 = [[RWTScaryBugDoc alloc] initWithTitle:@"House Centipede" rating:3 thumbImage:[UIImage imageNamed:@"centipedeThumb.jpg"] fullImage:[UIImage imageNamed:@"centipede.jpg"]];
//    RWTScaryBugDoc *bug3 = [[RWTScaryBugDoc alloc] initWithTitle:@"Wolf Spider" rating:5 thumbImage:[UIImage imageNamed:@"wolfSpiderThumb.jpg"] fullImage:[UIImage imageNamed:@"wolfSpider.jpg"]];
//    RWTScaryBugDoc *bug4 = [[RWTScaryBugDoc alloc] initWithTitle:@"Lady Bug" rating:1 thumbImage:[UIImage imageNamed:@"ladybugThumb.jpg"] fullImage:[UIImage imageNamed:@"ladybug.jpg"]];
//    NSMutableArray *bugs = [NSMutableArray arrayWithObjects:bug1, bug2, bug3, bug4, nil];
//    masterController.bugs = bugs;
    
    // 通过 NSCoding 获取之前固化保存的数据源
    NSMutableArray *loadedBugs = [RWTScaryBugDatabase loadScaryBugDocs];
    masterController.bugs = loadedBugs;

    return YES;
}

@end
