//
//  HQLTabBar.h
//  HQLTabBarController
//
//  Created by Qilin Hu on 2021/3/20.
//

#import <UIKit/UIKit.h>
@class HQLTabBar, HQLTabBarItem;

NS_ASSUME_NONNULL_BEGIN

@protocol HQLTabBarDelegate <NSObject>

- (BOOL)tabBar:(HQLTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

- (void)tabBar:(HQLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface HQLTabBar : UIView

@property (nonatomic, weak) id<HQLTabBarDelegate> delegate;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) HQLTabBarItem *selectedItem;
@property (nonatomic, readonly) UIView *backgroundView;
@property (nonatomic, strong) UIImage *backgroundImage;

// contentEdgeInsets 可用于将 items 置于 tabBar 的中心位置
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@property (nonatomic, getter=isTranslucent) BOOL translucent;

- (void)setHeight:(CGFloat)height;

/// 返回 tabBar items 中的最小高度
- (CGFloat)minimumContentHeight;

@end

NS_ASSUME_NONNULL_END
