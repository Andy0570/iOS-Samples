//
//  PECircleSpreadPresentedController.m
//  PETransition
//
//  Created by Petry on 16/9/17.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PECircleSpreadPresentedController.h"
#import "PEInteractiveTransition.h"
#import "Masonry.h"
#import "PECircleSpreadTransition.h"


@interface PECircleSpreadPresentedController ()<UIViewControllerTransitioningDelegate>
/** 转场动画 */
@property (nonatomic, strong)PEInteractiveTransition *interactiveTransition;
@end

@implementation PECircleSpreadPresentedController

- (instancetype)init
{
    if (self = [super init]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

//- (CGRect)buttonFrame
//{
//    //转换到masonry的坐标系
//    CGPoint newP = CGPointMake(_presentButtonFrame.origin.x + _presentButtonFrame.size.width/2 - [UIScreen mainScreen].bounds.size.width/2, _presentButtonFrame.origin.y + _presentButtonFrame.size.height/2 - [UIScreen mainScreen].bounds.size.height/2);
//    _presentButtonFrame.origin = newP;
//    return _presentButtonFrame;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"7.jpg"]];
    [self.view addSubview:imageV];
    imageV.frame = self.view.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点击或向\n下滑动dismiss" forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    //转换到masonry的坐标系
    CGRect tempRect = _presentButtonFrame;
    CGPoint newP = CGPointMake(_presentButtonFrame.origin.x + _presentButtonFrame.size.width/2 - [UIScreen mainScreen].bounds.size.width/2, _presentButtonFrame.origin.y + _presentButtonFrame.size.height/2 - [UIScreen mainScreen].bounds.size.height/2);
    _presentButtonFrame.origin = newP;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_presentButtonFrame.origin).priorityLow();
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.greaterThanOrEqualTo(self.view);
        make.top.greaterThanOrEqualTo(self.view).offset(64);
        make.bottom.right.lessThanOrEqualTo(self.view);
    }];
    self.interactiveTransition = [PEInteractiveTransition interactiveTransitionWithTransitionType:PEInteractiveTransitionTypeDismiss GestureDirection:PEInteractiveTransitionGestureDirectionDown];
    [self.interactiveTransition addPanGestureForViewController:self];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [button addGestureRecognizer:pan];
    self.presentButtonFrame = tempRect;
//    NSLog(@"presentB:%@",NSStringFromCGRect(self.presentButtonFrame));

}

- (void)pan:(UIPanGestureRecognizer *)panGesture{
    UIView *button = panGesture.view;
    CGPoint newCenter = CGPointMake([panGesture translationInView:panGesture.view].x + button.center.x - [UIScreen mainScreen].bounds.size.width / 2, [panGesture translationInView:panGesture.view].y + button.center.y - [UIScreen mainScreen].bounds.size.height / 2);
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(newCenter).priorityLow();
    }];
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    self.presentButtonFrame = button.frame;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ---UIViewControllerTransitioningDelegate---
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [PECircleSpreadTransition transitionWithTransitionType:PECircleSpreadTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [PECircleSpreadTransition transitionWithTransitionType:PECircleSpreadTransitionTypeDismiss];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactiveTransition.interation ? self.interactiveTransition : nil;
}

@end
