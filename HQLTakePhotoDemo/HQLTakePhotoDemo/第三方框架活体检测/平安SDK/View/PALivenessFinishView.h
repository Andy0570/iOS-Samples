//
//  PALivenessFinishView.h
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/3/30.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PALivenessController.h" // 需要使用失败的枚举类型

/**
 活体检测回调时，显示成功/失败视图
 */

@protocol PALivenessFinishViewDelegate <NSObject>

@required
// 点击重新检测按钮，回调该方法
- (void)finishViewRecheckButtonDidClicked;

// 点击返回按钮，回调该方法
- (void)finishViewBackButtonDidClicked;

@end

@interface PALivenessFinishView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<PALivenessFinishViewDelegate>)delegate;
- (void)setFailureType:(PALivenessControllerDetectionFailureType)FailureType;

@end
