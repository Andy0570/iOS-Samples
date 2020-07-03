//
//  MYColorBackView.h
//  MYPresentedController_Example
//
//  Created by 孟遥 on 2017/2/23.
//  Copyright © 2017年 mengyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYColorBackView : UIView

//背景颜色View
@property (nonatomic, strong) UIView *backColorView;
//占位，覆盖导航视图控制器的透明视图
@property (nonatomic, strong) UIView *topView;

@end
