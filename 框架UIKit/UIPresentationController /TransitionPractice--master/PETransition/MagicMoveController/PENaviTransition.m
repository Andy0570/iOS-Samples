//
//  PENaviTransition.m
//  PETransition
//
//  Created by Petry on 16/9/11.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PENaviTransition.h"
#import "PEMagicMoveController.h"
#import "PEMagicMoveCell.h"
#import "PEMagicMovePushController.h"


@interface PENaviTransition()
/** 动画过渡代理管理的是push还是pop */
@property (nonatomic, assign)PENaviTransitionType type;
@end
@implementation PENaviTransition

+ (instancetype)transitionWithType:(PENaviTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(PENaviTransitionType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.75;
}
/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case PENaviTransitionTypePush:
            [self doPushAnimation:transitionContext];
            break;
        case PENaviTransitionTypePop:
            [self doPopAnimation:transitionContext];
            break;
            
        default:
            break;
    }
}

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PEMagicMoveController *fromVC = (PEMagicMoveController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PEMagicMovePushController *toVC = (PEMagicMovePushController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到当前点击的cell的imageView
    PEMagicMoveCell *cell = (PEMagicMoveCell *)[fromVC.collectionView cellForItemAtIndexPath:fromVC.clickIndex];
    UIView *containerView = [transitionContext containerView];
//    UIView *tempView = [cell.imageV snapshotViewAfterScreenUpdates:NO];
    UIImage *image = [cell.imageV imageFromView];
    UIView *tempView = [[UIImageView alloc] initWithImage:image];
    tempView.frame = cell.imageV.frame;
    
    //将点击的cell截图作为临时View的内容 并将坐标系转化成push控制器种的坐标
    tempView.frame = [cell.imageV convertRect:cell.imageV.bounds toView:containerView];
    //设置动画前的各个控件的状态
    cell.imageV.hidden = YES;
    toVC.view.alpha = 0;
    toVC.imageView.hidden = YES;
    //tempView添加到containerView中保证在最前方,所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    //开始push动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1/0.55 options:0 animations:^{
        //临时View(也就是截取cell大小)的frame变成和push出来view种的imageView大小一样
        tempView.frame = [toVC.imageView convertRect:toVC.imageView.bounds toView:containerView];
        //push控制器由透明为0变为1
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        toVC.imageView.hidden = NO;
        //如果动画过渡取消了就标记不完成,否则标记完成,这里可以直接写YES,如果有手势过渡才需要判断,必须标记,否则系统不会完成动画,会出现无法交互等bug
        [transitionContext completeTransition:YES];
    }];
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PEMagicMovePushController *fromVC = (PEMagicMovePushController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PEMagicMoveController *toVC = (PEMagicMoveController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    PEMagicMoveCell *cell = (PEMagicMoveCell *)[toVC.collectionView cellForItemAtIndexPath:toVC.clickIndex];
    UIView *containerView = [transitionContext containerView];
    //这里的lastObject就是push适合初始化的那个tempView
    UIView *tempView = containerView.subviews.lastObject;
    //设置动画前状态
    cell.imageV.hidden = YES;       //列表页面的cell先隐藏
    fromVC.imageView.hidden = YES;  //当前页面的imageView也进行隐藏
    tempView.hidden = NO;           //最上面的临时View显示
    [containerView insertSubview:toVC.view atIndex:0];
    //开始pop动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:.55 initialSpringVelocity:1/0.55 options:0 animations:^{
        //将临时View的坐标和大小变成新坐标系中列表cell的坐标和大小
        tempView.frame = [cell.imageV convertRect:cell.imageV.bounds toView:containerView];
        //同时详情页面隐藏
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //加入了手势判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            //手势取消了,原来隐藏的imageView要显示出来
            tempView.hidden = YES;
            fromVC.imageView.hidden = NO;
        }else{
            //手势成功
            cell.imageV.hidden = NO;        //列表点击的cell要显示
            [tempView removeFromSuperview]; //临时的要去除 因为下一次会重新生成 不会产生冗余
        }
    }];
}


@end
