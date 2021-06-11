//
//  ActionSheetCityPicker.h
//  UIAlertController
//
//  Created by Qilin Hu on 2021/6/10.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AbstractActionSheetPicker.h"
#import "HQLProvince.h"

NS_ASSUME_NONNULL_BEGIN

@class ActionSheetCityPicker;
typedef void(^ActionCityDoneBlock)(ActionSheetCityPicker *picker, HQLProvince *selectedProvince, HQLCity *selectedCity);
typedef void(^ActionCityCancelBlock)(ActionSheetCityPicker *picker);

/// MARK: 省份城市选择器
@interface ActionSheetCityPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>

/// target 方法
+ (instancetype)showPickerWithTitle:(NSString *)title initialProvince:(HQLProvince *_Nullable)province initialCity:(HQLCity *_Nullable)city target:(id)target successAction:(SEL _Nullable)successAction cancelAction:(SEL _Nullable)cancelActionOrNil origin:(id)origin;

- (instancetype)initWithTitle:(NSString *)title initialProvince:(HQLProvince *_Nullable)province initialCity:(HQLCity *_Nullable)city target:(id)target successAction:(SEL _Nullable)successAction cancelAction:(SEL _Nullable)cancelActionOrNil origin:(id)origin;

/// block 方法
+ (instancetype)showPickerWithTitle:(NSString *)title initialProvince:(HQLProvince *_Nullable)province initialCity:(HQLCity *_Nullable)city target:(id)target doneBlock:(ActionCityDoneBlock)doneBlock cancelBlock:(ActionCityCancelBlock)cancelBlock origin:(id)origin;

- (instancetype)initWithTitle:(NSString *)title initialProvince:(HQLProvince *_Nullable)province initialCity:(HQLCity *_Nullable)city target:(id)target doneBlock:(ActionCityDoneBlock)doneBlock cancelBlock:(ActionCityCancelBlock)cancelBlock origin:(id)origin;

@property (nonatomic, copy) ActionCityDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionCityCancelBlock onActionSheetCancel;

@end

NS_ASSUME_NONNULL_END
