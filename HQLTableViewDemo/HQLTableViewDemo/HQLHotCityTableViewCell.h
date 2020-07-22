//
//  HQLHotCityTableViewCell.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQLCity;

NS_ASSUME_NONNULL_BEGIN

typedef void(^HotCityButtonActionBlock)(NSString *cityCode, NSString *cityName);

/// 热门城市
@interface HQLHotCityTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray<HQLCity *> *hotCities;
@property (nonatomic, copy) HotCityButtonActionBlock hotCityButtonAction;

@end

NS_ASSUME_NONNULL_END
