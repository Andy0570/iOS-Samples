//
//  UIViewController+HQLTabBar.m
//  HQLFancyTabBarController
//
//  Created by Qilin Hu on 2021/3/20.
//

#import "UIViewController+HQLTabBar.h"
#import "HQLTabBarController.h"
#import <objc/runtime.h>

@implementation UIViewController (HQLTabBar)

// 视图控制器将要显示，如果该视图控制器不是 nav 的根视图控制器，则隐藏 tabBar
- (void)customViewWillAppear:(BOOL)animated {
    if (self.navigationController.childViewControllers.count > 1) {
        [self.hql_tabBarController setTabBarHidden:YES animated:NO];
    }
    [self customViewWillAppear:animated];
}

// 视图控制器已经显示，如果该视图控制器是 nav 的根视图控制器，则显示 tabBar
- (void)customViewDidAppear:(BOOL)animated {
    if (self.navigationController.childViewControllers.count == 1) {
        [self.hql_tabBarController setTabBarHidden:NO animated:NO];
    }
    
    [self customViewDidAppear:animated];
}

// 视图控制器将要消失
- (void)customViewWillDisappear:(BOOL)animated {
    // 设置返回按钮 (backBarButtonItem 的图片不能设置；如果用 leftBarButtonItem 属性，则 iOS7 自带的滑动返回功能会失效)
    if (!self.navigationItem.backBarButtonItem && self.navigationController.viewControllers.count > 1) {
        self.navigationItem.backBarButtonItem = [self backButton];
    }
    [self customViewWillDisappear:animated];
}

#pragma mark - BackButton

- (UIBarButtonItem *)backButton {
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = NSLocalizedString(@"返回", nil);
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(goBack_Swizzle);
    return temporaryBarButtonItem;
}

- (void)goBack_Swizzle {
    [self.navigationController popViewControllerAnimated:YES];
}

+ (void)load {
    Class class = [UIViewController class];
    
    Method originMethod = class_getInstanceMethod(class, @selector(viewWillAppear:));
    Method newMethod = class_getInstanceMethod(class, @selector(customViewWillAppear:));
    method_exchangeImplementations(originMethod, newMethod);
    
    originMethod = class_getInstanceMethod(class, @selector(viewDidAppear:));
    newMethod = class_getInstanceMethod(class, @selector(customViewDidAppear:));
    method_exchangeImplementations(originMethod, newMethod);
    
    originMethod = class_getInstanceMethod(class, @selector(viewWillDisappear:));
    newMethod = class_getInstanceMethod(class, @selector(customViewWillDisappear:));
    method_exchangeImplementations(originMethod, newMethod);
}

@end
