//
//  HQLCityPickerSearchResultController.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/2/1.
//

#import <UIKit/UIKit.h>
@class HQLCity;

NS_ASSUME_NONNULL_BEGIN

typedef void(^HQLCityPickerSearchResultSelectionBlock)(HQLCity *city);

@interface HQLCityPickerSearchResultController : UITableViewController

@property (nonatomic, copy, nullable) NSArray<HQLCity *> *searchResultCities;
@property (nonatomic, copy) HQLCityPickerSearchResultSelectionBlock selectionBlock;

@end

NS_ASSUME_NONNULL_END
