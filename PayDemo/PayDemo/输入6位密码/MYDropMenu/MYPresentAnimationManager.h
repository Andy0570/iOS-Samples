//
//  MYPresentAnimationManager.h
//  上拉,下拉菜单
//
//  Created by 孟遥 on 16/10/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define my_Screen_Width  [UIScreen mainScreen].bounds.size.width
#define my_Screen_Height  [UIScreen mainScreen].bounds.size.height
#define my_Screen_Bounds [UIScreen mainScreen].bounds

typedef NS_ENUM(NSInteger){
    
    //从上到下降动画
    MYPresentedViewShowStyleFromTopDropStyle       = 0,
    //从上倒到下展开动画
    MYPresentedViewShowStyleFromTopSpreadStyle     = 1,
    //从上到下弹簧效果
    MYPresentedViewShowStyleFromTopSpringStyle     = 2,
    //从下到上下降动画
    MYPresentedViewShowStyleFromBottomDropStyle    = 3,
    //从下到上展开动画
    MYPresentedViewShowStyleFromBottomSpreadStyle  = 4,
    //从下到上弹簧效果
    MYPresentedViewShowStyleFromBottomSpringStyle  = 5,
    //直接呈现效果
    MYPresentedViewShowStyleSuddenStyle            = 6,
    //左上角收缩效果
    MYPresentedViewShowStyleShrinkTopLeftStyle     = 7,
    //左下角收缩效果
    MYPresentedViewShowStyleShrinkBottomLeftStyle  = 8,
    //右上角收缩效果
    MYPresentedViewShowStyleShrinkTopRightStyle    = 9,
    //右下角收缩效果
    MYPresentedViewShowStyleShrinkBottomRightStyle = 10
    
}MYPresentedViewShowStyle;

@interface MYPresentAnimationManager : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

//记录当前模态状态
@property (nonatomic, assign,getter=isPresented) BOOL presented;
//动画类型
@property (assign, nonatomic) MYPresentedViewShowStyle showStyle;
//frame
@property (assign, nonatomic) CGRect showViewFrame;
//是否显示暗色蒙板
@property (nonatomic, assign,getter=isNeedClearBack) BOOL clearBack;

@end
