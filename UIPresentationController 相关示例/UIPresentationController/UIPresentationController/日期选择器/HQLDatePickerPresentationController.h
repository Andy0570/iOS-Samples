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
 * 1.创建一个继承 UIPresentationController 的子类
 * 2.遵守并实现 UIViewControllerTransitioningDelegate 协议
 * 其实也可以写成两个类，分别继承 UIPresentationController 和实现 UIViewControllerTransitioningDelegate 协议
 */
@interface HQLDatePickerPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@end

NS_ASSUME_NONNULL_END

/**
 UIPresentationController 对象为所呈现的视图控制器提供高级视图转换管理功能，实现视图控制器之间的转场动画。
 
 
 遵守 UIViewControllerTransitioningDelegate 协议的作用：
 告诉控制器，谁是动画主管 (UIPresentationController)，哪个类负责开始动画的具体细节、哪个类负责结束动画的具体细节。
 
 
 UIPresentationController 子类的作用：
 负责「被呈现」及「负责呈现」的 controller 以外的 controller, 比如显示带渐变效果的黑色半透明背景视图。
 在此步骤，起码需要重写以下 5 个方法：
 1. - (void)presentationTransitionWillBegin; // 跳转将要开始时执行
 2. - (void)presentationTransitionDidEnd:(BOOL)completed; // 跳转已经结束时执行
 3. - (void)dismissalTransitionWillBegin; // 返回将要开始时执行
 4. - (void)dismissalTransitionDidEnd:(BOOL)completed; // 返回已经结束时执行
 5. frameOfPresentedViewInContainerView // 跳转完成后，被呈现视图在容器视图中的位置
 
 // Position of the presented view in the container view by the end of the presentation transition.
 // 呈现过渡动画结束时，被呈现的视图在容器视图中的位置。
 // (Default: container view bounds)
 @property(nonatomic, readonly) CGRect frameOfPresentedViewInContainerView;
 */
