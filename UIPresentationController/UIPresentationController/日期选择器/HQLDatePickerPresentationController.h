//
//  HQLDatePickerPresentationController.h
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
@interface HQLDatePickerPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@end

NS_ASSUME_NONNULL_END

/**
 遵守 UIViewControllerAnimatedTransitioning 协议的作用：
 告诉控制器，谁是动画主管 (UIPresentationController)，哪个类负责开始动画的具体细节、哪个类负责结束动画的具体细节。
 
 UIPresentationController 子类的作用：
 负责「被呈现」及「负责呈现」的 controller 以外的 controller, 比如带渐变效果的黑色半透明背景 View。
 在此步骤，起码需要重写以下 5 个方法：
 1. - (void)presentationTransitionWillBegin;
 2. - (void)presentationTransitionDidEnd:(BOOL)completed;
 3. - (void)dismissalTransitionWillBegin;
 4. - (void)dismissalTransitionDidEnd:(BOOL)completed;
 5. frameOfPresentedViewInContainerView
 
 // Position of the presented view in the container view by the end of the presentation transition.
 // 呈现过渡动画结束时，被呈现的视图在容器视图中的位置。
 // (Default: container view bounds)
 @property(nonatomic, readonly) CGRect frameOfPresentedViewInContainerView;
 */
