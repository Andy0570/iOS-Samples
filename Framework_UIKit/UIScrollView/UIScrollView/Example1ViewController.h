//
//  Example1ViewController.h
//  UIScrollView
//
//  Created by Qilin Hu on 2020/12/7.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UIScrollView 使用示例
 
 参考：
 <https://www.jianshu.com/p/391079d3fe35>
 <https://www.jianshu.com/p/ba88e12eddc2>
  
 Scroll View Programming Guide for iOS
 <https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/UIScrollView_pg/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008179-CH1-SW1>
 
 PageControl: Using a Paginated UIScrollView:
 <https://developer.apple.com/library/archive/samplecode/PageControl/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007795>
 */
@interface Example1ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 UIScrollView 的三个主要组件：contentSize、contentOffset 和 contentInset。

 * contentSize 用来标识 UIScrollView 的可滚动范围；
 * contentOffset 用来设置 UIScrollView 的视图原点与当前可视区域左上角的距离；
 * contentInset 用于设置边缘插入量，或者说，额外的视图内边距；
 */
