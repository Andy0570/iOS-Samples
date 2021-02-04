//
//  AAPLSwipeTransitionInteractionController.h
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 从指定的屏幕边缘跟踪 UIScreenEdgePanGestureRecognizer 手势识别器，并得出过渡完成的百分比。
 
 可交互动画需要传递三个动作：
 
 - (void)updateInteractiveTransition:(CGFloat)percentComplete;
 - (void)cancelInteractiveTransition;
 - (void)finishInteractiveTransition;
 
 */
@interface AAPLSwipeTransitionInteractionController : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer edgeForDragging:(UIRectEdge)edge NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
