//
//  HQLMainViewController.h
//  NavigationControllerDemo
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义导航栏：定位 + 搜索栏 + 购物车 + 扫一扫
 
 全局主题颜色通过 Chameleon 框架在 AppDelegate 中设置。
 
 参考：
 * <https://stackoverflow.com/questions/45350035/ios-11-searchbar-in-navigationbar>
 
 */
@interface HQLMainViewController : UIViewController

@end

NS_ASSUME_NONNULL_END


/**
 
 // 您可以通过添加高度约束 44 来更改 iOS 11 中 UISearchBar 的高度：
 if (@available(iOS 11.0, *)) {
    [searchBar.heightAnchor constraintEqualToConstant:44].active = YES;
  }
 
 */
