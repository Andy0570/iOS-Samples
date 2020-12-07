//
//  HQLExample2ViewController.h
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/13.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 第一个示例中，WKWebView 的加载和刷新代码全都融合在 UIViewController 中，造成了视图控制器十分臃肿。
 从“高内聚、低耦和”的角度考虑，我把带有 WKWebView 的 Cell 提取为单独的一个子类 HQLWebViewCell
 */
@interface HQLExample2ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
