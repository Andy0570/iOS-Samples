//
//  HQLCityPickerController.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/30.
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
