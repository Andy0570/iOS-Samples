//
//  MasterViewController.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) NSMutableArray *bugs; // 数据源：<HQLScaryBugDoc> 对象

@end

