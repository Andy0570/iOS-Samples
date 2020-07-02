//
//  HQLFullScreenPresentationController.h
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/2.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 实现自定义过渡动画：
 * 1.继承 UIPresentationController 成为子类
 * 2.遵守 UIViewControllerAnimatedTransitioning 协议
 * 其实也可以写成两个类，分别继承 UIPresentationController 和实现 UIViewControllerAnimatedTransitioning 协议
 */
@interface HQLFullScreenPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@end

NS_ASSUME_NONNULL_END

/**
 我们的 UIPresentationController 的子类是负责「被呈现」及「负责呈现」的 controller 以外的 controller 的。
 
 看着很绕口，说白了，在我们的例子中，它负责的仅仅是那个带渐变效果的黑色半透明背景 View。
 而 UIViewControllerAnimatedTransitioning 类将会负责「被呈现」的 ViewController 的过渡动画
 */
