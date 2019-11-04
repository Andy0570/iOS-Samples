//
//  AppDelegate.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
Ray Wenderlich iOS 入门教程 Demo。
 
 https://www.raywenderlich.com/1797/ios-tutorial-how-to-create-a-simple-iphone-app-part-1
 https://www.raywenderlich.com/1845/ios-tutorial-how-to-create-a-simple-iphone-app-tutorial-part-2
 https://www.raywenderlich.com/1768/uiview-tutorial-for-ios-how-to-make-a-custom-uiview-in-ios-5-a-5-star-rating-view
 
 相关知识
 * UISplitViewController，主从列表视图
 * UITableViewController，列表视图的编辑：添加、删除
 * UI元素的使用：UITextField、UIButton、UIImageView、UILabel
 * 自定义评分视图：XHRageView
 * 添加照片时，使用图片选择器：UIImagePickerController 从照片库选择图片。
 * AppIcon、LaunchImage
 * 使用第三方框架 SVProgressHUD 显示加载状态
 * 多线程编程 GCD
 * MVC设计模式
 * StroyBoard ：拖拽添加UI、关联对象、自动布局、Segues 的使用
 *
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 创建 Core Data  堆栈
// #1 数据模型的结构信息
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
// #2 数据持久层和对象模型协调器
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
// #3 对象的上下文 managedObject 模型
@property (nonatomic, strong, readwrite) NSManagedObjectContext *context;

@end

