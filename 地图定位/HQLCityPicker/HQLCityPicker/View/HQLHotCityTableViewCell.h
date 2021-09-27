//
//  HQLHotCityTableViewCell.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>
@class HQLCity;

NS_ASSUME_NONNULL_BEGIN

/// 通过 Block 对象返回选中的城市模型
typedef void(^HQLHotCityButtonActionBlock)(HQLCity *city);

/// 热门城市
@interface HQLHotCityTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray<HQLCity *> *hotCities;
@property (nonatomic, copy) HQLHotCityButtonActionBlock hotCityButtonAction;

@end

NS_ASSUME_NONNULL_END
