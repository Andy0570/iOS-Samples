//
//  HQLCityPickerController.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 城市选择完成后执行的 Block 块，返回城市代码和城市名称
typedef void(^HQLCityPickerCompletionBlock)(NSString *cityCode, NSString *cityName);

/// 城市选择器
@interface HQLCityPickerController : UITableViewController

@property (nonatomic, copy) HQLCityPickerCompletionBlock completionBlock;

@end

NS_ASSUME_NONNULL_END
