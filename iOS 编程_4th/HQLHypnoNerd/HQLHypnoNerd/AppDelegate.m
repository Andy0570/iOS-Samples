//
//  AppDelegate.m
//  HQLHypnoNerd
//
//  Created by ToninTech on 16/8/19.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "AppDelegate.h"
#import "HQLHyponsisViewController.h"
#import "HQLReminderViewController.h"
#import "QuizViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 设置根视图控制器
    // UIWindow 对象提供了一个方法将视图控制器的视图层次结构加入应用窗口：setRootViewController,当程序将某个视图控制器设置为UIWindow对象的rootViewControl时，UIWindow对象会将该视图控制器的view作为子视图加入窗口，此外，还会自动调整view的大小，将其设置为与窗口的大小相同。rootViewControl的view需要在应用启动完毕之后就显示，所以UIWindow 对象会在设置完rootViewControl后立刻加载其view
    
    // 【标签项1】
    HQLHyponsisViewController *hvc = [[HQLHyponsisViewController alloc] init];
//    self.window.rootViewController=hvc;
    
    // 向视图控制器发送 init 消息会调用指定初始化方法 initWithNibName：bundle：并为两个参数都传入nil,即使向一个需要使用NIB文件的视图控制器发送init消息，UIViewControl对象仍然会在应用程序中查找和当前UIViewControl子类同名的XIB文件。
    
    // 【标签项2】
    HQLReminderViewController *rvc = [[HQLReminderViewController alloc] init];
    
    // 获取指向 NSbundle 对象的指针，该 NSBundle 对象代表应用程序的主程序包
    // mainBundle 主程序包对应于文件系统中项目的根目录
//    NSBundle *appBundle = [NSBundle mainBundle];
//    
     //告诉初始化方法在appBundle中查找HQLReminderViewController.xib文件
//    HQLReminderViewController *rvc = [[HQLReminderViewController alloc] initWithNibName:@"HQLReminderViewController"
//                    bundle:appBundle];

    // 【标签项3】
    QuizViewController *qvc = [[QuizViewController alloc] init];
    
    // 创建 UITabBarcontroller 对象
    // 保存一组视图控制器，使应用能够在两个视图控制器的对象之间自由的切换
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[hvc,rvc,qvc];
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
