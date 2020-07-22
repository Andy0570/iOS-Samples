//
//  HQLCitySelectionHeaderView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 城市分组首字符
@interface HQLCitySelectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic, readwrite, copy) NSString *headerTitle;
@end

NS_ASSUME_NONNULL_END
