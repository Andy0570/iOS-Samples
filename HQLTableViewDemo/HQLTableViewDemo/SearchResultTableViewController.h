//
//  SearchResultTableViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultTableViewController : UITableViewController <UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray *dataList;   // 原始数据
@end

NS_ASSUME_NONNULL_END
