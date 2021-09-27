//
//  HQLCityPickerSearchResultController.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//  Released under an MIT license: http://opensource.org/licenses/MIT
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
