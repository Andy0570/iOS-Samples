//
//  UITwoTableViewController.h
//  HQLTableViewDemo
//
//  Created by ToninTech on 2017/1/17.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 左右TableView的联动Demo，在一个视图控制器上放2相互关联的TabelView：
 
 💡💡💡 实现原理 💡💡💡
 * 与方式三在UI上的区别：右侧列表显示所有数据源。
 * 视图层次结构：UIViewController 中放左右两个 UITableView；
 * 点击左侧 UITableView 中的 cell，自动滚动右侧 UITableView ；
 * 当用户点击或者滚动右侧列表时，自动反向选中左侧列表。
 */
@interface UITwoTableViewController : UIViewController

@end
