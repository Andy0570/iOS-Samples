//
//  PEPageTurningTransition.m
//  PETransition
//
//  Created by Petry on 16/9/14.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEPageTurningTransition.h"
#import "UIView+anchorPoint.h"
#import "UIView+FrameChange.h"

@implementation PEPageTurningTransition

+ (instancetype)transitionWithType:(PEPageTurningTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(PEPageTurningTransitionType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

#pragma mark - ---UIViewControllerAnimatedTransitioning---
//动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}
//自定义过渡动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.type) {
        case PEPageTurningTransitionTypePush:
            [self doPushAnimation:transitionContext];
            break;
        case PEPageTurningTransitionTypePop:
            [self doPopAnimation:transitionContext];
            break;
            
        default:
            break;
    }
}

/**
 *  自定义push动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //对当前view截图 然后作为动画对象
//    UIView *tempV = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    UIImage *image = [fromVC.view imageFromView];
    UIView *tempV = [[UIImageView alloc] initWithImage:image];
    tempV.frame = fromVC.view.frame;
    
    UIView *containerV = [transitionContext containerView];
    //临时的放最上面 做过渡
    [containerV addSubview:toVC.view];
    [containerV addSubview:tempV];
    fromVC.view.hidden = YES;
    //设置anchorPoint 选择的支点
    [tempV setAnchorPoint:CGPointMake(0, 0.5)];
    CATransform3D transform3d = CATransform3DIdentity;
    //m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
    transform3d.m34 = -0.002;
    containerV.layer.sublayerTransform = transform3d;
    //增加阴影
    CAGradientLayer *fromGradient = [CAGradientLayer layer];
    fromGradient.frame = fromVC.view.bounds;
    fromGradient.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor blackColor].CGColor];
    fromGradient.startPoint = CGPointMake(0.0, 0.5);
    fromGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *fromShadow = [[UIView alloc] initWithFrame:fromVC.view.bounds];
    fromShadow.backgroundColor = [UIColor clearColor];
    [fromShadow.layer insertSublayer:fromGradient atIndex:1];
    fromShadow.alpha = 0.0;
    [tempV addSubview:fromShadow];
    CAGradientLayer *toGradient = [CAGradientLayer layer];
    toGradient.frame = fromVC.view.bounds;
    toGradient.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor blackColor].CGColor];
    toGradient.startPoint = CGPointMake(0.0, 0.5);
    toGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *toShadow = [[UIView alloc] initWithFrame:fromVC.view.bounds];
    toShadow.backgroundColor = [UIColor clearColor];
    [toShadow.layer insertSublayer:toGradient atIndex:1];
    toShadow.alpha = 1.0;
    [toVC.view addSubview:toShadow];
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //沿Y轴旋转 逆时针180°
        tempV.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        //当前的由亮变暗 push的VC由暗变亮
        fromShadow.alpha = 1.0;
        toShadow.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        //动画取消的操作
        if ([transitionContext transitionWasCancelled]){
            [tempV removeFromSuperview];
            fromVC.view.hidden = NO;
        }
    }];
}

/**
 *  自定义pop动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerV = [transitionContext containerView];
    UIView *tempV = containerV.subviews.lastObject;
    [containerV addSubview:toVC.view];
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //临时图层恢复原状
        tempV.layer.transform = CATransform3DIdentity;
        fromVC.view.subviews.lastObject.alpha = 1.0;
        tempV.subviews.lastObject.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]){
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
            [tempV removeFromSuperview];
            toVC.view.hidden = NO;
        }
    }];
}

@end
