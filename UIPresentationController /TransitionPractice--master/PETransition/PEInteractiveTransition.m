//
//  PEInteractiveTransition.m
//  PETransition
//
//  Created by Petry on 16/9/11.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEInteractiveTransition.h"

@interface PEInteractiveTransition()

/** 传入的ViewController */
@property (nonatomic, weak)UIViewController *vc;
/** 手势方向 */
@property (nonatomic, assign)PEInteractiveTransitionGestureDirection direction;
/** 手势类型 */
@property (nonatomic, assign)PEInteractiveTransitionType type;

@end
@implementation PEInteractiveTransition

+ (instancetype)interactiveTransitionWithTransitionType:(PEInteractiveTransitionType)type GestureDirection:(PEInteractiveTransitionGestureDirection)direction
{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(PEInteractiveTransitionType)type GestureDirection:(PEInteractiveTransitionGestureDirection)direction{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}
/**
 *  手势过渡过程
 *
 *  @param pan 添加的手势
 */
- (void)handleGesture:(UIPanGestureRecognizer *)pan
{
    //手势百分比 初始化为0  向上和向右滑动 距离是负的 所以前面加负号 这样负负得正
    CGFloat persent = 0;
    switch (_direction) {
        case PEInteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = -[pan translationInView:pan.view].y;
            persent = transitionY / pan.view.frame.size.width;
        }
            break;
        case PEInteractiveTransitionGestureDirectionRight:{
            CGFloat transitionR = [pan translationInView:pan.view].x;
            persent = transitionR / pan.view.frame.size.width;
        }
            break;
        case PEInteractiveTransitionGestureDirectionDown:{
            CGFloat transitionD = [pan translationInView:pan.view].y;
            persent = transitionD / pan.view.frame.size.width;
        }
            break;
        case PEInteractiveTransitionGestureDirectionLeft:{
            CGFloat transitionL = -[pan translationInView:pan.view].x;
            persent = transitionL / pan.view.frame.size.width;
        }
            break;
            
        default:
            break;
    }
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            //手势开始的时候标记手势状态,并开始相应的事件
            self.interation = YES;
            [self startGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中,通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动的距离是否过半,过则finishInteractiveTransition完成转场操作,否则取消转场操作
            self.interation = NO;
            if (persent > 0.5) {
                [self finishInteractiveTransition];
            }else {
                [self cancelInteractiveTransition];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)startGesture
{
    switch (_type) {
        case PEInteractiveTransitionTypePresent:{
            if (_presentConfig) {
                _presentConfig();
            }
        }
            break;
        case PEInteractiveTransitionTypeDismiss:{
            [_vc dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case PEInteractiveTransitionTypePush:{
            if (_pushConfig) {
                _pushConfig();
            }
        }
            break;
        case PEInteractiveTransitionTypePop:{
            [_vc.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
