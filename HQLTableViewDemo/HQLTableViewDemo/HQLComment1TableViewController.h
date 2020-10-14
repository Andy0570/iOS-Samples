//
//  HQLComment1TableViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/13.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 评论列表示例1
 
 1. 模块架构遵循 MVC 设计模式；
 2. 通过 sectionHeaderView + Cell +  sectionFooterView 实现 UI 布局，
    并显示一个 UITableViewStyleGrouped 样式的列表；
 3. 通过 Masonry 框架实现自动布局；
 4. 通过 YYKit 框架实现富文本点击事件；
 
 参考：
 * [iOS 实现微信朋友圈评论回复功能（一）](https://www.jianshu.com/p/395bac3648a7)
 * [iOS 实现微信朋友圈评论回复功能（二）](https://www.jianshu.com/p/733733fd042d)
 * [iOS 实现优酷视频的评论回复功能](https://www.jianshu.com/p/feb14f4eee1c)
 * [提升 UITableView 性能 - 复杂页面的优化](http://tutuge.me/2015/02/19/%E6%8F%90%E5%8D%87UITableView%E6%80%A7%E8%83%BD-%E5%A4%8D%E6%9D%82%E9%A1%B5%E9%9D%A2%E7%9A%84%E4%BC%98%E5%8C%96/)
 */
@interface HQLComment1TableViewController : UITableViewController

@end

NS_ASSUME_NONNULL_END
