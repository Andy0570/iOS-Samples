//
//  MYPresentedController.m
//  上拉,下拉菜单
//
//  Created by 孟遥 on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//


#import "MYPresentedController.h"


@interface MYPresentedController ()

//动画管理
@property (nonatomic, strong) MYPresentAnimationManager *animationManager;

@end

@implementation MYPresentedController

//管理
- (MYPresentAnimationManager *)animationManager
{
    if (!_animationManager) {
        _animationManager = [[MYPresentAnimationManager alloc]init];
    }
    return _animationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (instancetype)initWithShowFrame:(CGRect)showFrame ShowStyle:(MYPresentedViewShowStyle)showStyle callback:(handleBack)callback
{
    //断言
//    NSParameterAssert(![@(showStyle)isKindOfClass:[NSNumber class]]||![@(isBottomMenu)isKindOfClass:[NSNumber class]]);
    if (self = [super init]) {
        
        //设置管理
        self.transitioningDelegate          = self.animationManager;
        self.modalPresentationStyle         = UIModalPresentationCustom;
        self.callback                       = callback;
        self.animationManager.showStyle     = showStyle;
        self.animationManager.showViewFrame = showFrame;
    }
    return self;
}



- (void)setClearBack:(BOOL)clearBack
{
    _clearBack = clearBack;
    
    self.animationManager.clearBack = clearBack;
}

@end
