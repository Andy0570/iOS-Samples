//
//  HQLHotCityTableViewCell.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/30.
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
