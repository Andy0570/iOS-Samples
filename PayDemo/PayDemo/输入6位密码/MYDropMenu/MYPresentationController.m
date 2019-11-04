//
//  MYPresentationController.m
//  上拉,下拉菜单
//
//  Created by 孟遥 on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MYPresentationController.h"
#import "MYColorBackView.h"

@interface MYPresentationController ()

//蒙板点击层 (只处理点击)
@property (nonatomic, strong) UIControl *coverView;
//蒙板背景展示图(只处理颜色展示)
@property (nonatomic, strong) MYColorBackView *colorBackView;
@end

@implementation MYPresentationController

- (MYColorBackView *)colorBackView
{
    if (!_colorBackView) {
        _colorBackView = [[MYColorBackView alloc]initWithFrame:my_Screen_Bounds];
        if (self.isNeedClearBack) {

            _colorBackView.backColorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.000001];
        }else{
            
            _colorBackView.backColorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            if (_showFrame.origin.y > 64) {
                _colorBackView.topView.backgroundColor   = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            }
        }
        [_colorBackView addSubview:self.coverView];
    }
    return _colorBackView;
}

//蒙板
- (UIControl *)coverView
{
    if (!_coverView) {
        
        _coverView = [[UIControl alloc]initWithFrame:my_Screen_Bounds];
        [_coverView addTarget:self action:@selector(coverViewTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverView;
}


//重写布局
- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    //容器frame,不能遮挡导航栏 , 透明除外
    self.containerView.frame = my_Screen_Bounds;
    self.presentedView.frame = self.showFrame;
    [self.containerView insertSubview:self.colorBackView belowSubview:self.presentedView];
}


//蒙板点击
- (void)coverViewTouch
{
    
    
    
//    CGFloat duraration = [self animationDuration];
    
    
    
    [UIView animateWithDuration:0.15 animations:^{
        self.colorBackView.backColorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.001];
        self.colorBackView.topView.backgroundColor       = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.001];
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    } completion:^(BOOL finished) {
        
        if ([self.presentedViewController isKindOfClass:[MYPresentedController class]]) {
            MYPresentedController *presentedVc           = (MYPresentedController *)self.presentedViewController;
            presentedVc.presented                        = NO;
        }
        [self.coverView removeFromSuperview];
    }];
}

- (CGFloat)animationDuration
{
    CGFloat duration = 0.0;
    switch (_style) {
        case MYPresentedViewShowStyleFromTopDropStyle:
        case MYPresentedViewShowStyleFromBottomDropStyle:
        case MYPresentedViewShowStyleFromTopSpreadStyle:
        case MYPresentedViewShowStyleFromBottomSpreadStyle:
            
            duration = 0.25;
            break;
        case MYPresentedViewShowStyleFromTopSpringStyle:
        case MYPresentedViewShowStyleFromBottomSpringStyle:
            
            duration = 0.5;
            break;
        case MYPresentedViewShowStyleSuddenStyle:
            
            duration = 0.1;
            break;
        default:
            break;
    }
    return duration;
}


@end
