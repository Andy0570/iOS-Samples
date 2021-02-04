//
//  HQLDemo3ViewController.h
//  UIStackView
//
//  Created by Qilin Hu on 2020/5/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 通过 Masonry 框架实现自动布局
 */
@interface HQLDemo3ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 参考：https://juejin.im/pin/5c3fd5126fb9a0301bb4a7c0
 
 今天分享一个 `UIStackView` 的小知识点，用 `UIStackView` 做水平或垂直布局很方便，搜了大多数 UIStackView
 的资料，大多是教大家如何使用的 axis、alignment 等属性的。最近使用时遇到了：把 `UIStackView` 中某个视图
 `hidden` 后，`UIStackView` 的布局会进行更新，只展示没有 `hidden` 的视图。

 例如，你有 5 个视图平等分显示，设置某个视图 `hidden` 之后，就会变成 4 个视图平等分了。

 有的时候这是我们期许的，而有的时候并不是；如果 `hidden` 某个视图后，不想更改其他视图布局，
 那么可以使用 `Masonry` 的方法
 */
