//
//  PEElasticOneController.m
//  PETransition
//
//  Created by Petry on 16/9/13.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEElasticOneController.h"
#import "PEInteractiveTransition.h"
#import "Masonry.h"
#import "PEElasticTransition.h"


@interface PEElasticOneController ()<UIViewControllerTransitioningDelegate>
/** 过渡动画 */
@property (nonatomic, strong)PEInteractiveTransition *interactiveTransition;
@end

@implementation PEElasticOneController

- (instancetype)init{
    if (self = [super init]) {
        //转场的代理
        self.transitioningDelegate = self;
        //设置转场的类型为自定义
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5.jpg"]];
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(40);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或者向下滑动dimiss" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(imageV.mas_bottom).offset(10);
    }];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.interactiveTransition = [PEInteractiveTransition interactiveTransitionWithTransitionType:PEInteractiveTransitionTypeDismiss GestureDirection:PEInteractiveTransitionGestureDirectionDown];
    [self.interactiveTransition addPanGestureForViewController:self];
}

- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(elasticOneControllerPressDissmiss)])
    {
        [self.delegate elasticOneControllerPressDissmiss];
    }
}

#pragma mark - ---UIViewControllerTransitioningDelegate---
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PEElasticTransition transitionWithTransitionType:PEElasticTransitionTypePresent];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [PEElasticTransition transitionWithTransitionType:PEElasticTransitionTypeDismiss];
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    PEInteractiveTransition *interactivePresent = [self.delegate interactiveTransitionForPresent];
    return interactivePresent.interation ? interactivePresent : nil;
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}

@end
