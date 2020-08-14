//
//  HQLFloatingTabBar.h
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLFloatingTabBar : UIView

@property (nonatomic, copy) dispatch_block_t leftBarButtonActionBlock;
@property (nonatomic, copy) dispatch_block_t rightBarButtonActionBlock;
@property (nonatomic, copy) dispatch_block_t publishBarButtonActionBlock;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)show;
- (void)executeCompressAnimation;
- (void)executeStretchAnimation;

@end

NS_ASSUME_NONNULL_END
