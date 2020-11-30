//
//  ButtonStateViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 UIControlState
 
 typedef NS_OPTIONS(NSUInteger, UIControlState) {
     UIControlStateNormal       = 0,                       // 正常状态
     UIControlStateHighlighted  = 1 << 0,                  // 高亮状态
     UIControlStateDisabled     = 1 << 1,                  // 禁用状态
     UIControlStateSelected     = 1 << 2,                  // 选中状态
     UIControlStateFocused NS_ENUM_AVAILABLE_IOS(9_0) = 1 << 3, // 仅适用于屏幕支持对焦时（iOS新加入 应该和3D Touch有关）
     UIControlStateApplication  = 0x00FF0000,              // 可用于应用程序使用的附加标志
     UIControlStateReserved     = 0xFF000000               // 标记保留供内部框架使用
 };
 */
@interface ButtonStateViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
