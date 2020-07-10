//
//  PEElasticTransition.m
//  PETransition
//
//  Created by Petry on 16/9/13.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEElasticTransition.h"
#import "UIView+FrameChange.h"

@interface PEElasticTransition()

/** type */
@property (nonatomic, assign)PEElasticTransitionType type;

@end

@implementation PEElasticTransition

+ (instancetype)transitionWithTransitionType:(PEElasticTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(PEElasticTransitionType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

#pragma mark - ---UIViewControllerAnimatedTransitioning---
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //弹出动画的时间长点0.5秒 回退动画短点0.25秒
    return _type == PEElasticTransitionTypePresent ? 0.5 : 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //弹出和回退动画分开写 这样逻辑更清晰
    switch (_type) {
        case PEElasticTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case PEElasticTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        default:
            break;
    }
}

/**
 *  presentAnimation
 */
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContent
{
    UIViewController *toVC = [transitionContent viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContent viewControllerForKey:UITransitionContextFromViewControllerKey];
    //snapshotViewAfterScreenUpdates:可以对某个试图截图,我们采用对这个截图做动画代替直接对toVC做动画,因为在手势过渡中直接使用toVC动画会和手势有冲突,如果不需要实现手势的话,就可以不是用截图了
//    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    UIImage *image = [fromVC.view imageFromView];
    UIView *tempView = [[UIImageView alloc] initWithImage:image];
    tempView.frame = fromVC.view.frame;
    
    //因为对截图做动画,fromVC开始是隐藏的
    fromVC.view.hidden = YES;
    //containerView:如果要对视图做转场动画,视图就必须加入containerView中才能进行,可以理解为containerView管理所有做转场动画的视图
    UIView *containerView = [transitionContent containerView];
    //将截图视图和toVC的view都加入containerView中 截图视图是fromVC所以先放 先放的在下面
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    //设置toVC的frame,因为是present出来不是全屏,而且在底部,如果不设置默认是整个屏幕,这里的containerView的frame就是整个屏幕
    toVC.view.frame = CGRectMake(0, containerView.height, containerView.width, 500);
    //开始动画,使用产生弹簧效果的方法
    [UIView animateWithDuration:[self transitionDuration:transitionContent] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        //1.让toVC向上移动 向上是负的
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -500);
        //2.让截图视图缩小即可
        tempView.transform = CGAffineTransformMakeScale(0.85, 0.85);
        
    } completion:^(BOOL finished) {
        //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不是用手势的话直接传YES也是可以的，我们必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在，会出现无法交互的情况
        [transitionContent completeTransition:![transitionContent transitionWasCancelled]];
        //转场失败后的处理
        if ([transitionContent transitionWasCancelled])
        {
            //失败后复原动画开始是的样子
            //1.把fromVC显示出来
            fromVC.view.hidden = NO;
            //2.移除截图视图,下次会重新生成
            [tempView removeFromSuperview];
        }
    }];
}

/**
 *  dismissAnimation
 */
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContent
{
    UIViewController *fromVC = [transitionContent viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContent viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //参照present动画的逻辑,present成功后,containerView的第一个子视图就是截图视图,我们将其取出做动画
    UIView *containerView = [transitionContent containerView];
    UIView *tempView = containerView.subviews[0];
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContent] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        //present使用的是transform,只需要恢复就可以了
        fromVC.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([transitionContent transitionWasCancelled]) {
            //标记失败
            [transitionContent completeTransition:NO];
        }else{
            //成功后,标记成功,让toVC显示出来,并移除截图视图
            [transitionContent completeTransition:YES];
            toVC.view.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}

@end
