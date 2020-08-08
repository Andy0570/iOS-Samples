//
//  HQLSuspensionBallManager.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/8/8.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@class HQLSuspensionBallManager;

NS_ASSUME_NONNULL_BEGIN

@protocol HQLSuspensionBallDelegate <NSObject>
/// 点击悬浮球的回调
- (void)suspensionBallClickAction:(HQLSuspensionBallManager *)suspensionBallManager;
@end

@interface HQLSuspensionBallManager : NSObject

@property (nonatomic, weak) id<HQLSuspensionBallDelegate> delegate;

+ (HQLSuspensionBallManager *)sharedSuspensionBallManager;

- (void)createSuspensionBall;

- (void)displaySuspensionBall;

- (void)hideSuspensionBall;

- (void)changeSuspensionBallAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
