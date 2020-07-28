//
//  AddressTableViewCell.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/26.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressItem;

/// 自定义 UITableViewCell：Label + 勾选图片
/// 每个竖排的省市区都是一个 TableView，下面的选项是一个 UITableViewCell
@interface AddressTableViewCell : UITableViewCell

// 数据源
@property (nonatomic, strong) AddressItem *item;

@end

/**
 我注意到新版的京东上面勾选图片是在最左边的，选中后会有一个滑动的动画。
 */
