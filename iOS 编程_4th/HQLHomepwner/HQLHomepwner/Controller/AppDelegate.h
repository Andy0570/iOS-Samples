//
//  AppDelegate.h
//  HQLHomepwner
//
//  Created by ToninTech on 16/8/30.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

/**
*  # 启动图片
*
*  在 Assets.xcassets - LaunchImage - Retina4 中放入一张 640*1136
*  的黑色启动图片是为了解决iOS真机测试时应用显示不全屏的问题，屏幕上下都会有高度大约40左右的黑色矩形
*  参考：<http://www.jianshu.com/p/af1cf62c5b90>
*
*/
