//
//  PALivenessFinishAnimationView.h
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/3/30.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 活体检测回调时，显示成功/失败动画
 */
@interface PALivenessFinishAnimationView : UIView

- (void)animationWithSuccess;
- (void)animationWithFailure;

@end
