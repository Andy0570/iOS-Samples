//
//  PECircleSpreadTransition.m
//  PETransition
//
//  Created by Petry on 16/9/17.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PECircleSpreadTransition.h"
#import "PECircleSpreadController.h"
#import "PECircleSpreadPresentedController.h"

@implementation PECircleSpreadTransition

+ (instancetype)transitionWithTransitionType:(PECircleSpreadTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(PECircleSpreadTransitionType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

#pragma mark - ---UIViewControllerAnimatedTransitioning---
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (self.type) {
        case PECircleSpreadTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case PECircleSpreadTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
            
        default:
            break;
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationController *fromVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerV = [transitionContext containerView];
    PECircleSpreadController *temp = fromVC.viewControllers.lastObject;
    [containerV addSubview:toVC.view];
    //画两个圆路径
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithOvalInRect:temp.buttonFrame];
    //始终用最大的x值和y值的平方根 来作为圆的半径 这样保证了圆点中心到最远的边的距离作为半径
    CGFloat x = MAX(temp.buttonFrame.origin.x, containerV.frame.size.width - temp.buttonFrame.origin.x);
    CGFloat y = MAX(temp.buttonFrame.origin.y, containerV.frame.size.height - temp.buttonFrame.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    //圆心 半径 开始角度 结束角度M_PI*2是360° 是否顺时针
    UIBezierPath *endCircle = [UIBezierPath bezierPathWithArcCenter:containerV.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    //创建CAShapLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCircle.CGPath;
    //将maskLayer作为toVC的遮盖
    toVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    //动画是添加到layer上的,所以必须为CGPath,再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCircle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(endCircle.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];   //动画速度: 先慢 后慢 中间快
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PECircleSpreadPresentedController *fromVC = (PECircleSpreadPresentedController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    PECircleSpreadController *temp = toVC.viewControllers.lastObject;
    UIView *containerV = [transitionContext containerView];
    //画两个圆的路径
    CGFloat radius = sqrtf(pow(containerV.frame.size.height, 2) + pow(containerV.frame.size.width, 2))/2.0;
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithArcCenter:containerV.center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    temp.buttonFrame = fromVC.presentButtonFrame;
    UIBezierPath *endCircle = [UIBezierPath bezierPathWithOvalInRect:temp.buttonFrame];
    //创建CAShapeLayer进行覆盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCircle.CGPath;
    fromVC.view.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCircle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(endCircle.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{ 
    switch (_type) {
        case PECircleSpreadTransitionTypePresent:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
        }
            break;
        case PECircleSpreadTransitionTypeDismiss:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                //去掉遮挡层
                [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
            }
        }
            break;
            
        default:
            break;
    }
}

@end
