//
//  CustomViewController.h
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 在内部实现自定义动画，以「障眼法」的方式实现半模态页面
 
 在此视图上添加自己的具体实现，通过 viewWillAppear 和 backgroundViewTapped，可以自定义出很绚的动画效果，
 这种动画方式只是给大家提供一种思路，实现问题的方法有很多，有时候很多效果感觉很难实现，也许它用了一些障眼法之类的。
 */
@interface CustomViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
