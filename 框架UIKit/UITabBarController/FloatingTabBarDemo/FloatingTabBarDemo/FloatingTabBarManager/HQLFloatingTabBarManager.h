//
//  HQLFloatingTabBarManager.h
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HQLFloatingTabBarManagerDelegate <NSObject>
- (void)selectBarButtonAtIndex:(NSUInteger)index;
@end

@interface HQLFloatingTabBarManager : NSObject

@property (nonatomic, weak) id<HQLFloatingTabBarManagerDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t publishButtonActionBlock;

+ (instancetype)sharedFloatingTabBarManager;

- (void)createFloatingTabBar;
- (void)displayFloatingTabBar;
- (void)hideFloatingTabBar;

- (void)compressFloatingTabBar;
- (void)stretchFloatingTabBar;

@end

NS_ASSUME_NONNULL_END
