//
//  PEMagicMovePushController.m
//  PETransition
//
//  Created by Petry on 16/9/11.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEMagicMovePushController.h"
#import "PEInteractiveTransition.h"
#import "Masonry.h"
#import "UIView+FrameChange.h"
#import "PENaviTransition.h"


@interface PEMagicMovePushController ()
/** 手势过渡代理 */
@property (nonatomic, strong)PEInteractiveTransition *interactiveTransition;
@end

@implementation PEMagicMovePushController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"move to son page";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.jpg"]];
    self.imageView = imageView;
    [self.view addSubview:imageView];
    imageView.center = CGPointMake(self.view.center.x, 210);
    imageView.bounds = CGRectMake(0, 0, 280, 280);
    UITextView *textView = [UITextView new];
    textView.text = @"这是类似于KeyNote的神奇移动效果,向右滑动可以通过手势控制pop动画";
    textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero).priorityLow();
        make.top.mas_equalTo(imageView.mas_bottom).offset(20);
    }];
    //初始化手势过渡的代理
    self.interactiveTransition = [PEInteractiveTransition interactiveTransitionWithTransitionType:PEInteractiveTransitionTypePop GestureDirection:PEInteractiveTransitionGestureDirectionRight];
    //给当前控制器的试图添加手势
    [self.interactiveTransition addPanGestureForViewController:self];

}

//返回手势过渡管理对象
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [PENaviTransition transitionWithType:operation == UINavigationControllerOperationPush ? PENaviTransitionTypePush : PENaviTransitionTypePop];
}

//返回转场动画过渡管理对象
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    //如果是手动出发则返回我们的UIPercentDrivenInteractiveTransition对象
    return _interactiveTransition.interation ? _interactiveTransition : nil;
}

- (void)dealloc
{
//    NSLog(@"已销毁");
}

@end
