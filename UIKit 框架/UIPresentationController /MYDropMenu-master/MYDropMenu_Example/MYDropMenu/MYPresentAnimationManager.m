//
//  MYPresentAnimationManager.m
//  上拉,下拉菜单
//
//  Created by 孟遥 on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MYPresentAnimationManager.h"
#import "MYPresentationController.h"

@implementation MYPresentAnimationManager

#pragma mark - UIViewControllerTransitioningDelegate

//返回自定义模态容器
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    
    MYPresentationController *presentationVc = [[MYPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    // 蒙版属性传入
    presentationVc.clearBack = _clearBack;
    presentationVc.showFrame = _showViewFrame;
    return presentationVc;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

//转场动画持续时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

//自定义转场动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGRect bottomStopFrame  = CGRectMake(_showViewFrame.origin.x, my_Screen_Height + _showViewFrame.size.height, _showViewFrame.size.width, _showViewFrame.size.height);
    CGRect topStopFrame     = CGRectMake(_showViewFrame.origin.x, -_showViewFrame.size.height, _showViewFrame.size.width, _showViewFrame.size.height);
    CGRect beginFrame       = CGRectZero;
    CGRect stopFrame        = CGRectZero;
    UIView *presentedView   = nil;
    
    if (_presented) {
        
        presentedView       = [transitionContext viewForKey:UITransitionContextFromViewKey];
        beginFrame          = _showViewFrame;
        stopFrame           = [self beginStopFrame:topStopFrame bottomStop:bottomStopFrame];
        
    }else{
        
        presentedView       = [transitionContext viewForKey:UITransitionContextToViewKey];
        stopFrame           = _showViewFrame;
        beginFrame          = [self beginStopFrame:topStopFrame bottomStop:bottomStopFrame];
    }
    
    UIView *container       = [transitionContext containerView];
    [container addSubview:presentedView];
    
    //动画
    [self animationBeginFrame:beginFrame stop:stopFrame view:presentedView context:transitionContext];
}



- (void)animationBeginFrame:(CGRect)beginFrame stop:(CGRect)stopFrame view:(UIView *)presentedView context:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //位移动画
    if ((_showStyle == MYPresentedViewShowStyleFromTopDropStyle)||(_showStyle == MYPresentedViewShowStyleFromBottomDropStyle)) {
        
        presentedView.frame     = beginFrame;
        
        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.25 animations:^{
            
            presentedView.frame = stopFrame;
        } completion:^(BOOL finished) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [transitionContext completeTransition:YES];
            strongSelf.presented = !strongSelf.presented;
        }];
        
        //伸展动画
    }else if((_showStyle == MYPresentedViewShowStyleFromTopSpreadStyle)||(_showStyle ==MYPresentedViewShowStyleFromBottomSpreadStyle)){
        
        if (_showStyle == MYPresentedViewShowStyleFromTopSpreadStyle) {
            presentedView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        }else{
            presentedView.layer.anchorPoint = CGPointMake(0.5, 1);
        }
        
        CGFloat scaleY   = 0;
        if (_presented) {
            
            scaleY       = 0.0001;
        }else{
            
            scaleY       = 1.0;
            presentedView.transform      = CGAffineTransformMakeScale(1.0, 0.0001);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            presentedView.transform      = CGAffineTransformMakeScale(1.0, scaleY);
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            _presented = scaleY == 0.00001 ? NO : YES;
        }];
        //弹簧效果
    }else if ((_showStyle == MYPresentedViewShowStyleFromBottomSpringStyle)||(_showStyle == MYPresentedViewShowStyleFromTopSpringStyle)){
        
        presentedView.frame     = beginFrame;
        [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:8.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            presentedView.frame = stopFrame;
        } completion:^(BOOL finished) {
           
            [transitionContext completeTransition:YES];
            _presented = !_presented;
        }];
        //直接呈现
    }else if(_showStyle == MYPresentedViewShowStyleSuddenStyle){
        
        _presented ? (presentedView.alpha = 1.0) : (presentedView.alpha = 0.00001);
        [UIView animateWithDuration:0.1 animations:^{
            
           _presented ? (presentedView.alpha = 0.00001) : (presentedView.alpha = 1.0);
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            _presented = !_presented;
        }];
    }else if (_showStyle ==MYPresentedViewShowStyleShrinkBottomRightStyle||
              _showStyle == MYPresentedViewShowStyleShrinkBottomLeftStyle||
              _showStyle == MYPresentedViewShowStyleShrinkTopRightStyle||
              _showStyle == MYPresentedViewShowStyleShrinkTopLeftStyle){
        //设置锚点
        switch (_showStyle) {
            case MYPresentedViewShowStyleShrinkBottomRightStyle:
            {
                presentedView.layer.anchorPoint = CGPointMake(1, 1);
            }
                break;
            case MYPresentedViewShowStyleShrinkBottomLeftStyle:
            {
                presentedView.layer.anchorPoint = CGPointMake(0, 1);
            }
                break;
            case MYPresentedViewShowStyleShrinkTopRightStyle:
            {
                presentedView.layer.anchorPoint = CGPointMake(1, 0);
            }
                break;
            case MYPresentedViewShowStyleShrinkTopLeftStyle:
            {
                presentedView.layer.anchorPoint = CGPointMake(0, 0);
            }
                break;
            default:
                break;
        }
        if (_presented) {
            [UIView animateWithDuration:0.3 animations:^{
                presentedView.alpha = 0.0001;
                presentedView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
                _presented = !_presented;
            }];
        }else{
            presentedView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            presentedView.alpha = 0.0001;
            [UIView animateWithDuration:0.3 animations:^{
                presentedView.alpha = 1;
                presentedView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
                _presented = !_presented;
            }];
        }
    }
}


- (CGRect)beginStopFrame:(CGRect)topStopFrame bottomStop:(CGRect)bottomStopFrame
{
    CGRect frame       = CGRectZero;
    switch (_showStyle) {
        case MYPresentedViewShowStyleFromTopDropStyle:
            
            frame      = topStopFrame;
            break;
        case MYPresentedViewShowStyleFromBottomDropStyle:
            
            frame      = bottomStopFrame;
            break;
        case MYPresentedViewShowStyleFromTopSpreadStyle:
            
            frame      = topStopFrame;
            break;
        case MYPresentedViewShowStyleFromBottomSpreadStyle:
            
            frame      = bottomStopFrame;
            break;
        case MYPresentedViewShowStyleFromTopSpringStyle:
            
            frame      = topStopFrame;
            break;
        case MYPresentedViewShowStyleFromBottomSpringStyle:
            
            frame      = bottomStopFrame;
            break;
        case MYPresentedViewShowStyleSuddenStyle:
            
            frame      = _showViewFrame;
            break;
        case MYPresentedViewShowStyleShrinkTopLeftStyle:
        case MYPresentedViewShowStyleShrinkTopRightStyle:
        case MYPresentedViewShowStyleShrinkBottomLeftStyle:
        case MYPresentedViewShowStyleShrinkBottomRightStyle:
            frame      = _showViewFrame;
            break;
        default:
            break;
    }
    return frame;
}

@end
