//
//  HQLExample1ViewController.h
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 演示 UITableView 与 WKWebView 混排
 
 !!!: 将 WKWebView 作为 UITableViewCell 的子视图加载
 
 !!!: 关键：要先将 WKWebView 放进 UIScrollview 中，再放进 UITableViewCell 中。
 视图层次结构：
 UITableViewCell
     - UIScrollView
         - WKWebView
 
 参考：
 - [UITableView 与 WKWebView 的嵌套与适配](https://juejin.im/post/5a31e67df265da430f321bbf)
 - [https://www.jianshu.com/p/42858f95ab43](https://www.jianshu.com/p/42858f95ab43)
 - [UIWebView 与 UITableView 的嵌套方案](https://www.jianshu.com/p/a66efa4f3a1a)
 - [UIWebView 与 tableView 嵌套的内存问题及解决方案](https://www.jianshu.com/p/a66efa4f3a1a)
 - [UITableView 的 beginUpdates 和 endUpdates](https://www.jianshu.com/p/6efc5cf5c569)
 
 
 - [UITableView 嵌套 WKWebView 的那些坑](https://www.jianshu.com/p/44cfcf0fd538)
 */
@interface HQLExample1ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
