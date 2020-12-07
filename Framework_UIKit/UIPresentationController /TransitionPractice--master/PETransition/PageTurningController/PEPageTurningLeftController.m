//
//  PEPageTurningLeftController.m
//  PETransition
//
//  Created by Petry on 16/9/14.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEPageTurningLeftController.h"
#import "Masonry.h"
#import "PEInteractiveTransition.h"
#import "PEPageTurningTransition.h"


@interface PEPageTurningLeftController ()
/** 动画过渡对象 */
@property (nonatomic, strong)PEInteractiveTransition *interactiveTransition;
/** 记录push还是pop */
@property (nonatomic, assign)UINavigationControllerOperation operation;
@end

@implementation PEPageTurningLeftController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"翻页效果";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
    [self.view addSubview:imageV];
    imageV.frame = self.view.frame;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点我或向右滑动" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(turnLeft) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(74);
    }];
    //初始化手势过渡代理
    self.interactiveTransition = [PEInteractiveTransition interactiveTransitionWithTransitionType:PEInteractiveTransitionTypePop GestureDirection:PEInteractiveTransitionGestureDirectionRight];
    //给控制器添加手势  
    [self.interactiveTransition addPanGestureForViewController:self];
}

- (void)turnLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ---UINavigationControllerDelegate---
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.operation = operation;
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [PEPageTurningTransition transitionWithType:operation == UINavigationControllerOperationPush ? PEPageTurningTransitionTypePush : PEPageTurningTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.operation == UINavigationControllerOperationPush) {
        PEInteractiveTransition *interactiveTransitionPush = [self.delegate interactiveTransitionForPush];
        return interactiveTransitionPush.interation ? interactiveTransitionPush : nil;
    }else{
        return self.interactiveTransition.interation ? self.interactiveTransition : nil;
    }
}

@end
