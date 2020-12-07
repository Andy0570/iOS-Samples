//
//  PEPageTurningController.m
//  PETransition
//
//  Created by Petry on 16/9/14.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "PEPageTurningController.h"
#import "Masonry.h"
#import "PEInteractiveTransition.h"
#import "PEPageTurningLeftController.h"


@interface PEPageTurningController ()<PEPageTurningLeftControllerDelegate>
/** 动画过渡对象 */
@property (nonatomic, strong)PEInteractiveTransition *interactiveTransition;
/** 记录push还是pop */
@property (nonatomic, assign)UINavigationControllerOperation operation;
@end

@implementation PEPageTurningController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"翻页效果";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    [self.view addSubview:imageV];
    imageV.frame = self.view.frame;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点我或向左滑动" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(turnRight) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(74);
    }];
    //初始化手势过渡代理
    self.interactiveTransition = [PEInteractiveTransition interactiveTransitionWithTransitionType:PEInteractiveTransitionTypePush GestureDirection:PEInteractiveTransitionGestureDirectionLeft];
    typeof (self)weakSelf = self;
    self.interactiveTransition.pushConfig = ^(){
        [weakSelf turnRight];
    };
    //给控制器添加手势  
    [self.interactiveTransition addPanGestureForViewController:self];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
    self.navigationItem.leftBarButtonItem = back;
    
}

- (void)backToRoot
{
    self.navigationController.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)turnRight
{
    PEPageTurningLeftController *pushVC = [PEPageTurningLeftController new];
    self.navigationController.delegate = pushVC;
    pushVC.delegate = self;
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPush
{
    return self.interactiveTransition;
}

@end
