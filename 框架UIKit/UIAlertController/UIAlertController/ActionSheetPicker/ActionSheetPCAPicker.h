//
//  ActionSheetPCAPicker.h
//  UIAlertController
//
//  Created by Qilin Hu on 2021/6/10.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AbstractActionSheetPicker.h"
#import "HQLProvince.h"

NS_ASSUME_NONNULL_BEGIN

@class ActionSheetPCAPicker;
typedef void(^ActionPCADoneBlock)(ActionSheetPCAPicker *picker, HQLProvince *selectedProvince, HQLCity *selectedCity, HQLArea *selectedArea);
typedef void(^ActionPCACancelBlock)(ActionSheetPCAPicker *picker);

/// MARK: 省份城市区域（Province-City-Area）选择器
@interface ActionSheetPCAPicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>

/// target 方法
+ (instancetype)showPickerWithTitle:(NSString *)title initialProvince:(HQLProvince *_Nullable)province initialCity:(HQLCity *_Nullable)city initialArea:(HQLArea *_Nullable)area target:(id _Nullable)target successAction:(SEL _Nullable)successAction cancelAction:(SEL _Nullable)cancelActionOrNil origin:(id)origin;

- (instancetype)initWithTitle:(NSString *)title initialProvince:(HQLProvince *_Nullable)province initialCity:(HQLCity *_Nullable)city initialArea:(HQLArea *_Nullable)area target:(id _Nullable)target successAction:(SEL _Nullable)successAction cancelAction:(SEL _Nullable)cancelActionOrNil origin:(id)origin;

/// block 方法
+ (instancetype)showPickerWithTitle:(NSString *)title initialProvince:(HQLProvince *_Nullable)province initialCity:(HQLCity *_Nullable)city initialArea:(HQLArea *_Nullable)area target:(id _Nullable)target doneBlock:(ActionPCADoneBlock)doneBlock cancelBlock:(ActionPCACancelBlock)cancelBlock origin:(id)origin;

- (instancetype)initWithTitle:(NSString *)title initialProvince:(HQLProvince *_Nullable)province initialCity:(HQLCity *_Nullable)city initialArea:(HQLArea *_Nullable)area target:(id _Nullable)target doneBlock:(ActionPCADoneBlock)doneBlock cancelBlock:(ActionPCACancelBlock)cancelBlock origin:(id)origin;

@property (nonatomic, copy) ActionPCADoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionPCACancelBlock onActionSheetCancel;

@end

NS_ASSUME_NONNULL_END
