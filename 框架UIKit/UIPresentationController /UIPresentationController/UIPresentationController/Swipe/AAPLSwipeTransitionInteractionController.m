//
//  AAPLSwipeTransitionInteractionController.m
//  UIPresentationController
//
//  Created by Qilin Hu on 2020/7/3.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AAPLSwipeTransitionInteractionController.h"

@interface AAPLSwipeTransitionInteractionController ()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readonly) UIRectEdge edge;
@end

@implementation AAPLSwipeTransitionInteractionController

#pragma mark - Initialize

- (void)dealloc {
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}

- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer edgeForDragging:(UIRectEdge)edge {
    NSAssert(edge == UIRectEdgeTop || edge == UIRectEdgeBottom ||
             edge == UIRectEdgeLeft || edge == UIRectEdgeRight,
             @"edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.");
    
    self = [super init];
    if (self) {
        _gestureRecognizer = gestureRecognizer;
        _edge = edge;
        
        // 将自身作为手势识别器的观察者，这样当用户移动手指时，该对象就能收到更新。
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
        
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithGestureRecognizer:edgeForDragging:" userInfo:nil];
}

#pragma mark - Actions

- (IBAction)gestureRecognizeDidUpdate:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            /**
             手势识别器的开始状态由视图控制器处理，为了响应该手势识别器状态，
             视图控制器会触发 presentation 或者 dismissal 操作
             */
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // 当我们正在拖动时，相应地更新 transition context
            // !!!: 通过滑动百分比更新交互动画
            [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            // 拖动完成时，根据手势拖动的距离来判断该完成还是取消
            if ([self percentForGesture:gestureRecognizer] >= 0.5f) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            // 其他异常情况，取消交互动画
            [self cancelInteractiveTransition];
            break;
    }
}

#pragma mark - Private

/**
 以百分比值的方式返回平移手势识别器与屏幕边缘的偏移量，以过渡容器视图宽度或高度。
 这是交互式过渡的完成百分比。
 */
- (CGFloat)percentForGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    
    /**
     获取一个静态的参考坐标点
     因为作为动画的一部分，视图控制器将在屏幕上和屏幕外滑动，所以我们希望在不会移动的视图的
     坐标空间中进行计算：transition context 的容器视图。
     */
    UIView *transitionContainerView = self.transitionContext.containerView;
    
    CGPoint locationInSourceView = [gesture locationInView:transitionContainerView];
    
    // 计算拖动百分比
    
    CGFloat width = CGRectGetWidth(transitionContainerView.bounds);
    CGFloat height = CGRectGetHeight(transitionContainerView.bounds);
    
    // 根据我们要拖动的边缘方向，返回一个适当的百分比。
    if (self.edge == UIRectEdgeRight)
        return (width - locationInSourceView.x) / width;
    else if (self.edge == UIRectEdgeLeft)
        return locationInSourceView.x / width;
    else if (self.edge == UIRectEdgeBottom)
        return (height - locationInSourceView.y) / height;
    else if (self.edge == UIRectEdgeTop)
        return locationInSourceView.y / height;
    else
        return 0.f;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 保存 transitionContext 以备之后使用
    self.transitionContext = transitionContext;
    
    [super startInteractiveTransition:transitionContext];
}

@end
