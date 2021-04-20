//
//  HQLTabBarController.m
//  HQLTabBarController
//
//  Created by Qilin Hu on 2021/3/19.
//

#import "HQLTabBarController.h"
#import "HQLTabBarItem.h"
#import <objc/runtime.h>

@interface UIViewController (HQLTabBarControllerItemInteral)

- (void)hql_setTabBarController:(HQLTabBarController *)tabBarController;

@end

@interface HQLTabBarController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, readwrite) HQLTabBar *tabBar;

@end

@implementation HQLTabBarController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tabBar];
    [self.view addSubview:self.contentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:self.selectedIndex];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize viewSize = self.view.bounds.size;
    CGFloat tabBarStartingY = viewSize.height;
    CGFloat contentViewHeight = viewSize.height;
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBar.frame);
    
    if (!tabBarHeight) {
        if (@available(iOS 11.0, *)) {
            CGFloat safeAreaBottom = UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
            tabBarHeight = 58.0f + safeAreaBottom / 1.5f;
        } else {
            tabBarHeight = 58.0f;
        }
    } else if (@available(iOS 11.0, *)) {
        CGFloat safeAreaBottom = UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
        tabBarHeight = 58.0f + safeAreaBottom / 1.5f;
    }
    
    if (!self.tabBarHidden) {
        tabBarStartingY = viewSize.height - tabBarHeight;
        if (!self.tabBar.isTranslucent) {
            contentViewHeight -= (self.tabBar.minimumContentHeight ? : tabBarHeight);
        }
    }
    
    self.tabBar.frame = CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight);
    self.contentView.frame = CGRectMake(0, 0, viewSize.width, contentViewHeight);
    self.selectedViewController.view.frame = self.contentView.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    
    return orientationMask;
}

#pragma mark - Custom Accessors

- (HQLTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[HQLTabBar alloc] init];
        _tabBar.delegate = self;
        _tabBar.backgroundColor = [UIColor clearColor];
        _tabBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
    }
    return _tabBar;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    return _contentView;
}

- (UIViewController *)selectedViewController {
    return [self.viewControllers objectAtIndex:self.selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if (self.selectedViewController) {
        [self.selectedViewController willMoveToParentViewController:nil];
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    self.tabBar.selectedItem = self.tabBar.items[selectedIndex];
    
    self.selectedViewController = [self.viewControllers objectAtIndex:selectedIndex];
    [self addChildViewController:self.selectedViewController];
    self.selectedViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.contentView addSubview:self.selectedViewController.view];
    [self.selectedViewController didMoveToParentViewController:self];
    
    [self.view setNeedsLayout];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:viewControllers.count];
        
        for (UIViewController *viewController in viewControllers) {
            HQLTabBarItem *tabBarItem = [[HQLTabBarItem alloc] init];
            tabBarItem.title = viewController.title;
            [tabBarItems addObject:tabBarItem];
            [viewController hql_setTabBarController:self];
        }
        
        self.tabBar.items = tabBarItems;
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController hql_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

// 返回 UIViewController 实例在 HQLTabBarController 的 viewControllers 数组中的索引
- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    while (searchedController.parentViewController != nil && searchedController.parentViewController != self) {
        searchedController = searchedController.parentViewController;
    }
    return [self.viewControllers indexOfObject:searchedController];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    // 确保任何挂起的布局已经完成，以防止伪造的动画
    [self.view layoutIfNeeded];
    
    _tabBarHidden = hidden;
    
    [self.view setNeedsLayout];
    
    if (!_tabBarHidden) {
        self.tabBar.hidden = NO;
    }
    
    [UIView animateWithDuration:(animated ? 0.24 : 0) animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.tabBarHidden) {
            self.tabBar.hidden = YES;
        }
    }];
}

- (void)setTabBarHidden:(BOOL)tabBarHidden {
    [self setTabBarHidden:tabBarHidden animated:NO];
}

#pragma mark - HQLTabBarDelegate

- (BOOL)tabBar:(HQLTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[index]]) {
            return NO;
        }
    }
    
    if (self.selectedViewController == self.viewControllers[index]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
            [self.delegate tabBarController:self didSelectItemAtIndex:index];
        }
        
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)self.selectedViewController;
            
            if (selectedController.topViewController != selectedController.viewControllers[0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(HQLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index <0 || index >= self.viewControllers.count) {
        return;
    }
    
    self.selectedIndex = index;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [self.delegate tabBarController:self didSelectViewController:self.viewControllers[index]];
    }
}

@end

#pragma mark - UIViewController+HQLTabBarControllerItem

@implementation UIViewController (HQLTabBarControllerItemInteral)

- (void)hql_setTabBarController:(HQLTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(hql_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (HQLTabBarControllerItem)

- (HQLTabBarController *)hql_tabBarController {
    HQLTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(hql_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController hql_tabBarController];
    }
    
    return tabBarController;
}

// self -> tabBarController -> index -> tabBarItem
- (HQLTabBarItem *)hql_tabBarItem {
    HQLTabBarController *tabBarController = [self hql_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [tabBarController.tabBar.items objectAtIndex:index];
}

- (void)hql_setTabBarItem:(HQLTabBarItem *)tabBarItem {
    HQLTabBarController *tabBarController = [self hql_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    HQLTabBar *tabBar = tabBarController.tabBar;
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:tabBar.items];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    tabBar.items = tabBarItems;
}

@end

