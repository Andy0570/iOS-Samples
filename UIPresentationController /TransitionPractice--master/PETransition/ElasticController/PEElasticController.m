//
//  PEElasticController.m
//  PETransition
//
//  Created by Petry on 16/9/13.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEElasticController.h"
#import "PEInteractiveTransition.h"
#import "Masonry.h"
#import "PEElasticOneController.h"



@interface PEElasticController ()<PEElasticOneControllerDelegate>
/** 过渡的代理 */
@property (nonatomic, strong)PEInteractiveTransition *interactiveTransition;
@end

@implementation PEElasticController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"弹性present";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4.jpg"]];
    
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(70);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或者向上滑动present" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(imageV.mas_bottom).offset(30);
    }];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];
    
    self.interactiveTransition = [PEInteractiveTransition interactiveTransitionWithTransitionType:PEInteractiveTransitionTypePresent GestureDirection:PEInteractiveTransitionGestureDirectionUp];
    typeof (self) weakSelf = self;
    self.interactiveTransition.presentConfig = ^(){
        [weakSelf present];
    };
    [self.interactiveTransition addPanGestureForViewController:self];
    
}

- (void)present
{
    PEElasticOneController *elasticVC = [PEElasticOneController new];
    elasticVC.delegate = self;
    [self presentViewController:elasticVC animated:YES completion:nil];
}

#pragma mark - ---PEElasticOneControllerDelegate---
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent
{
    return self.interactiveTransition;
}
- (void)elasticOneControllerPressDissmiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
