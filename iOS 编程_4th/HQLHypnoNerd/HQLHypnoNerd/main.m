//
//  main.m
//  HQLHypnoNerd
//
//  Created by ToninTech on 16/8/19.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        // UIApplicationMain 函数:
        // 1.创建一个 UIApplication 对象（每个iOS应用都有且只有一个该对象）
        // 作用:维护运行循环
        
        // 2.UIApplicationMain 函数还会创建某个指定类的对象，并将其设置为 UIApplication 对象的delegate，该对象的类是由 UIApplicationMain 函数得最后一个实参指定的，该实参的类型是NSString对象，代表的某个类的类名
        // 所以以下代码中，UIApplicationMain 会创建一个 AppDelegate 对象，并将其设置为UIApplication 对象的 delegate
        // 在应用启动运行循环并开始接收事件前，UIApplication 对象会向其委托发送一个特定的消息（didFinishLaunchingWithOptions:）完成相应的初始化工作
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
