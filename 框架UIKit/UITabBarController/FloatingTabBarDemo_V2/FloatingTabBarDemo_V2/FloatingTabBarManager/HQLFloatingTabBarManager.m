//
//  HQLFloatingTabBarManager.m
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLFloatingTabBarManager.h"
#import <YYKit.h>
#import "HQLFloatingTabBar.h"

static HQLFloatingTabBarManager *_sharedInstance = nil;

@interface HQLFloatingTabBarManager ()

@property (nonatomic, strong) HQLFloatingTabBar *floatingTabBar;
@property (nonatomic, assign) BOOL delegateFlag;

@end

@implementation HQLFloatingTabBarManager

#pragma mark - Initialize

+ (instancetype)sharedFloatingTabBarManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Custom Accessors

- (HQLFloatingTabBar *)floatingTabBar {
    if (!_floatingTabBar) {
        CGRect frame = CGRectMake(CGFloatPixelRound((kScreenWidth - 200) / 2), CGFloatPixelRound((kScreenHeight - 102)), 200, 50);
        _floatingTabBar = [[HQLFloatingTabBar alloc] initWithFrame:frame];
        
        __weak __typeof(self)weakSelf = self;
        _floatingTabBar.leftBarButtonActionBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.delegateFlag) {
                [strongSelf.delegate selectBarButtonAtIndex:0];
            }
        };
        
        _floatingTabBar.rightBarButtonActionBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.delegateFlag) {
                [strongSelf.delegate selectBarButtonAtIndex:1];
            }
        };
        
        _floatingTabBar.publishBarButtonActionBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf.publishButtonActionBlock) {
                strongSelf.publishButtonActionBlock();
            }
        };
    }
    return _floatingTabBar;
}

- (void)setDelegate:(id<HQLFloatingTabBarManagerDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag = [delegate respondsToSelector:@selector(selectBarButtonAtIndex:)];
}

#pragma mark - Public

- (void)createFloatingTabBar {
    [self.floatingTabBar show];
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
    [mainWindow.rootViewController.view bringSubviewToFront:self.floatingTabBar];
}

- (void)showFloatingTabBar {
    self.floatingTabBar.hidden = NO;
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
    [mainWindow.rootViewController.view bringSubviewToFront:self.floatingTabBar];
}

- (void)hideFloatingTabBar {
    self.floatingTabBar.hidden = YES;
}

- (void)compressFloatingTabBar {
    [self.floatingTabBar executeCompressAnimation];
}

- (void)stretchFloatingTabBar {
    [self.floatingTabBar executeStretchAnimation];
}

@end
