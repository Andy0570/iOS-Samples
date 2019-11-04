//
//  HQLFirstTableViewController.h
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 方法一列表，类似于QQ分组
 
 💡💡💡 实现原理 💡💡💡
 * 通过代理方法将 headerView 自定义为 UIButton 按钮。
 * 设置 UIButton 的 tag 值 = section 值以标记按钮被点击时所属的 section 段。
 * 使用 NSMutableArray 数组保存每一段 Section 的展开（1）/收缩（0）状态。
 
 * README文档：https://www.jianshu.com/p/d1d983a6588b
 */
@interface HQLFirstTableViewController : UITableViewController

@end
