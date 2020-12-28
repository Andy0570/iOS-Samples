//
//  AppDelegate.m
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import "AppDelegate.h"
#import "FRPGalleryViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) PXAPIHelper *apiHelper;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *consumerKey = @"DC2To2BS0ic1ChKDK15d44M42YHf9gbUJgdFoF0m";
    NSString *consumerSecret = @"i8WL4chWoZ4kw9fh3jzHK7XzTer1y5tUNvsTFNnB";
    [PXRequest setConsumerKey:consumerKey consumerSecret:consumerSecret];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    FRPGalleryViewController *vc = [[FRPGalleryViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
