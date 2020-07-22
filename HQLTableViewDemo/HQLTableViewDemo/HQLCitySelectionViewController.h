//
//  HQLCitySelectionViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HQLCitySelectionBlock)(NSString *cityCode, NSString *cityName);

/**
 !!!: 城市选择器，参考 <https://github.com/houshixian/CityList>
 
 FIXME: HQLTableIndexView 的手势索引动画待修复！
 FIXME: 搜索时，点击遮罩层视图，无法退出搜索！
 */
@interface HQLCitySelectionViewController : UIViewController

@property (nonatomic, copy) HQLCitySelectionBlock citySelectionBlock;

@end

NS_ASSUME_NONNULL_END
