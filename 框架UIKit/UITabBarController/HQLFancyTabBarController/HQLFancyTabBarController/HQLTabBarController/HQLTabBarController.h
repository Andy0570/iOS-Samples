//
//  HQLTabBarController.h
//  HQLTabBarController
//
//  Created by Qilin Hu on 2021/3/20.
//  MARK: Inspired From <https://github.com/robbdimitrov/RDVTabBarController>

#import <UIKit/UIKit.h>
#import "HQLTabBar.h"
@class HQLTabBarController;

NS_ASSUME_NONNULL_BEGIN

@protocol HQLTabBarControllerDelegate <NSObject>

- (BOOL)tabBarController:(HQLTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(HQLTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(HQLTabBarController *)tabBarController didSelectItemAtIndex:(NSInteger)index;

@end

@interface HQLTabBarController : UIViewController <HQLTabBarDelegate>

@property (nonatomic, weak) id<HQLTabBarControllerDelegate> delegate;

@property (nonatomic, copy) IBOutletCollection(UIViewController) NSArray *viewControllers;

@property (nonatomic, readonly) HQLTabBar *tabBar;

@property (nonatomic, weak) UIViewController *selectedViewController;

@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)tabBarHidden animated:(BOOL)animated;

@end

@interface UIViewController (HQLTabBarController)

@property (nonatomic, setter=hql_setTabBarItem:) HQLTabBarItem *hql_tabBarItem;

@property (nonatomic, readonly) HQLTabBarController *hql_tabBarController;

@end

NS_ASSUME_NONNULL_END
