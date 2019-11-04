//
//  HQLDepartmentViewController.h
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/21.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 展开收缩列表-方法三：
 
 💡💡💡 实现原理 💡💡💡
 * 模仿「微医」APP实现的医院科室选择列表，左右联动样式。
 * 视图层次结构：UIViewController 中放左右两个 UITableView；
 * 点击左侧 UITableView 中的 cell，更新右侧 UITableView 的数据源；
 * 左侧 UITableView 的 cell 是自定义的，因为需要设置点击动画箭头和背景颜色；
 
 */
@interface HQLDepartmentViewController : UIViewController

@end
