//
//  main.m
//  1.1 Quiz
//
//  Created by ToninTech on 16/8/11.
//  Copyright © 2016年 ToninTech. All rights reserved.
//
/**
 * MVC design model
 *IOS应用：Quiz
 *
 *功能：在视图中显示一个问题，用户点击视图下方的按钮，可以显示相应的答案，用户
 *     点击上方的按钮，则会显示一个新的问题
 *四个视图对象：UILabel/UIButton
 *两个控制器对象：AppDelegate、QuizViewControl的对象各一个
 *NSArray的对象两个
 */
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
