//
//  AAPLSwipeTransitionDelegate.h
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAPLSwipeTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>

//! If this transition will be interactive, this property is set to the
//! gesture recognizer which will drive the interactivity.
// 可交互式的转换
@property (nonatomic, strong, nullable) UIScreenEdgePanGestureRecognizer *gestureRecognizer;

@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end

NS_ASSUME_NONNULL_END
