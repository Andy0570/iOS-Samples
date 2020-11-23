//
//  MasterViewController.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DetailViewController;

/// 主列表视图控制器
@interface MasterViewController : UITableViewController

@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) NSMutableArray *bugs; // 数据源：<HQLScaryBugDoc> 对象

@end

NS_ASSUME_NONNULL_END
