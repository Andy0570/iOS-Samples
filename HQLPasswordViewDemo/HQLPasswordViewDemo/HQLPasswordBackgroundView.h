//
//  HQLPasswordBackgroundView.h
//  HQLPasswordViewDemo
//
//  Created by ToninTech on 2017/6/19.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HQLPasswordBackgroundViewBlock)(void);

/**
 密码输入框背景视图
 */
@interface HQLPasswordBackgroundView : UIView

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 取消支付Block */
@property (nonatomic, copy) HQLPasswordBackgroundViewBlock closeBlock;
/** 忘记密码Block */
@property (nonatomic, copy) HQLPasswordBackgroundViewBlock forgetPasswordBlock;

/** 根据字符串长度重设圆点 */
- (void)resetDotsWithLength:(NSUInteger)length;

/** 开启、关闭用户交互按钮 */
- (void)enableAllButton:(BOOL)enable;

- (CGRect)textFieldRect;

@end
