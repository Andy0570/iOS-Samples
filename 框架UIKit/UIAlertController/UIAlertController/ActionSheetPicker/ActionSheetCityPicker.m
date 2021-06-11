//
//  ActionSheetCityPicker.m
//  UIAlertController
//
//  Created by Qilin Hu on 2021/6/10.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "ActionSheetCityPicker.h"
#import "HQLProvinceManager.h"

@interface ActionSheetCityPicker ()
@property (nonatomic, strong) HQLProvinceManager *provinceManager;
@end

@implementation ActionSheetCityPicker

#pragma mark - Initialize

/// target 方法
+ (instancetype)showPickerWithTitle:(NSString *)title initialProvince:(HQLProvince *)province initialCity:(HQLCity *)city target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    ActionSheetCityPicker *picker = [[ActionSheetCityPicker  alloc] initWithTitle:title initialProvince:province initialCity:city target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [picker showActionSheetPicker];
    return picker;
}

/// 指定初始化方法
- (instancetype)initWithTitle:(NSString *)title initialProvince:(HQLProvince *)province initialCity:(HQLCity *)city target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [super initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    if (self) {
        self.title = title;
        
        // 初始化省份城市数据
        self.provinceManager = [HQLProvinceManager sharedManager];
        if (province) {
            self.provinceManager.currentProvince = province;
        }
        if (city) {
            self.provinceManager.currentCity = city;
        }
    }
    return self;
}

/// block 方法
+ (instancetype)showPickerWithTitle:(NSString *)title initialProvince:(HQLProvince *)province initialCity:(HQLCity *)city target:(id)target doneBlock:(ActionCityDoneBlock)doneBlock cancelBlock:(ActionCityCancelBlock)cancelBlock origin:(id)origin {
    ActionSheetCityPicker *picker = [[ActionSheetCityPicker alloc] initWithTitle:title initialProvince:province initialCity:city target:target doneBlock:doneBlock cancelBlock:cancelBlock origin:origin];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title initialProvince:(HQLProvince *)province initialCity:(HQLCity *)city target:(id)target doneBlock:(ActionCityDoneBlock)doneBlock cancelBlock:(ActionCityCancelBlock)cancelBlock origin:(id)origin {
    self = [self initWithTitle:title initialProvince:province initialCity:city target:target successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlock;
    }
    return self;
}

- (UIView *)configuredPickerView {
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *cityPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    cityPicker.delegate = self;
    cityPicker.dataSource = self;
    
    // 选择器选中默认值：省份
    if (self.provinceManager.currentProvince) {
        NSInteger currentProvinceIndex = [self.provinceManager.provinces indexOfObject:self.provinceManager.currentProvince];
        [cityPicker selectRow:currentProvinceIndex inComponent:0 animated:NO];
        
        // 选择器选中默认值：城市
        if (self.provinceManager.currentCity) {
            NSInteger currentCityIndex = [self.provinceManager.currentProvince.children indexOfObject:self.provinceManager.currentCity];
            [cityPicker selectRow:currentCityIndex inComponent:1 animated:NO];
        } else {
            if (self.provinceManager.currentProvince.children.count != 0) {
                [cityPicker selectRow:0 inComponent:1 animated:NO];
            }
        }
    }
    
    self.pickerView = cityPicker;
    return cityPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
        self.onActionSheetDone(self, self.provinceManager.currentProvince, self.provinceManager.currentCity);
    } else if (target && [target respondsToSelector:successAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:successAction withObject:self.provinceManager withObject:origin];
#pragma clang diagnostic pop
    }
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        self.onActionSheetCancel(self);
    } else if (target && [target respondsToSelector:cancelAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark - <UIPickerViewDataSource>

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            // 返回省份个数
            return self.provinceManager.provinces.count;
            break;
        case 1:
            // 返回当前省份的城市数
            return self.provinceManager.currentProvince.children.count;
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - <UIPickerViewDelegate>

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            // 第一列返回省份名字
            HQLProvince *province = (HQLProvince *)self.provinceManager.provinces[row];
            return province.name;
            break;
        }
        case 1: {
            // 第二列返回城市名字
            HQLCity *city = (HQLCity *)self.provinceManager.currentProvince.children[row];
            return city.name;
            break;
        }
        default: {
            return NULL;
            break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            HQLProvince *currentProvince = (HQLProvince *)self.provinceManager.provinces[row];
            self.provinceManager.currentProvince = currentProvince;
            [pickerView reloadComponent:1];
            break;
        }
        case 1: {
            HQLCity *currentCity = (HQLCity *)self.provinceManager.currentProvince.children[row];
            self.provinceManager.currentCity = currentCity;
            break;
        }
        default:
            break;
    }
}

@end
