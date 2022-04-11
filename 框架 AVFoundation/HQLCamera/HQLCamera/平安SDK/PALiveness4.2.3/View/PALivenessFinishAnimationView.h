//
//  PALivenessFinishAnimationView.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 活体检测回调时，显示成功/失败动画
 */
@interface PALivenessFinishAnimationView : UIView

- (void)animationWithSuccess;
- (void)animationWithFailure;

@end
