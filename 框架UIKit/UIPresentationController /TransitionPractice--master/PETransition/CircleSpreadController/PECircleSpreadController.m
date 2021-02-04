//
//  PECircleSpreadController.m
//  PETransition
//
//  Created by Petry on 16/9/17.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PECircleSpreadController.h"
#import "Masonry.h"
#import "UIView+FrameChange.h"
#import "PECircleSpreadPresentedController.h"

@interface PECircleSpreadController ()
/** 按钮 */
@property (nonatomic, weak)UIButton *button;
@end

@implementation PECircleSpreadController

- (void)setButtonFrame:(CGRect)buttonFrame
{ 
    _button.frame = buttonFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6.jpg"]];
    [self.view addSubview:imageV];
    imageV.frame = self.view.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    [button setTitle:@"点击或\n拖动我" forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, 0)).priorityLow();
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.greaterThanOrEqualTo(self.view);
        make.top.greaterThanOrEqualTo(self.view).offset(64);
        make.bottom.right.lessThanOrEqualTo(self.view);
    }];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [button addGestureRecognizer:pan];
}

- (void)present
{
    PECircleSpreadPresentedController *presentVC = [PECircleSpreadPresentedController new];
    presentVC.presentButtonFrame = self.buttonFrame;
    [self presentViewController:presentVC animated:YES completion:nil];
}

- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    UIView *button = pan.view;
    //因为make.center是以屏幕中心点作为(0,0)点 所以要减去屏幕一半
    CGPoint newCenter = CGPointMake([pan translationInView:pan.view].x + button.center.x - [UIScreen mainScreen].bounds.size.width / 2, [pan translationInView:pan.view].y + button.center.y - [UIScreen mainScreen].bounds.size.height / 2);
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(newCenter).priorityLow();
    }];
   
    //每次都需要复位 重新计算偏移量
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (CGRect)buttonFrame
{
    return _button.frame;
}

@end
