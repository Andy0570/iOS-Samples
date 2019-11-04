//
//  HQLFoldingCell.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/16.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Folding animation types

 - FCAnimationOpen:  打开方向
 - FCAnimationClose: 关闭方向
 */
typedef NS_ENUM(NSUInteger, FCAnimationType) {
    FCAnimationOpen,
    FCAnimationClose
};

typedef void(^animationCompletion)(NSError *error);
typedef void(^foldTapHandler)(void);

@interface RotatedView : UIView

@property (nonatomic) RotatedView *backView;

- (void)addBackViewHeight:(CGFloat)height color:(UIColor *)color;

- (void)foldingAnimation:(NSString *)timing
                    from:(CGFloat)fromPoint
                      to:(CGFloat)toPoint
                   delay:(NSTimeInterval)delay
                duration:(NSTimeInterval)duration
                  hidden:(BOOL)hidden;

@end

@interface HQLFoldingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet RotatedView *foregroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foregroundTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;

- (BOOL)isAnimating;
- (CGFloat)returnSumTime;
- (void)fold_imageTap:(foldTapHandler)handler;

- (void)selectedAnimation:(BOOL)selected animation:(BOOL)animated completion:(animationCompletion)completion;

@end

NS_ASSUME_NONNULL_END
