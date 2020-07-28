//
//  HQLProvinceManager.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/7/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLProvinceManager.h"
#import <YYKit.h>
#import "HQLPropertyListStore.h"

static NSString * const KJSONFileName = @"ProvinceCity.json";

static HQLProvinceManager *_sharedManager = nil;

@interface HQLProvinceManager ()
@property (nonatomic, readwrite, copy) NSArray *provinceArray;
@end

@implementation HQLProvinceManager

#pragma mark - Initialize

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        [_sharedManager loadProvinceData];
    });
    return _sharedManager;
}

#pragma mark - Public

- (void)setCurrentCityCode:(NSString *)code; {
    if (![code isNotBlank]) return;
    
    // 根据当前城市代码找到所属省份
    [self.provinceArray enumerateObjectsUsingBlock:^(HQLProvince *currentProvince, NSUInteger idx, BOOL * _Nonnull stop) {
        [currentProvince.children enumerateObjectsUsingBlock:^(HQLCity *currentCity, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([currentCity.code isEqualToString:code]) {
                self.currentCity = currentCity;
                self.currentProvince = currentProvince;
            }
        }];
    }];
}

#pragma mark - Private

- (void)loadProvinceData {
    HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithJSONFileName:KJSONFileName modelsOfClass:HQLProvince.class];
    self.provinceArray = store.dataSourceArray;
    
    // 初始化并设置默认值
    self.currentProvince = _provinceArray.firstObject;
    self.currentCity = _currentProvince.children.firstObject;
}

#pragma mark - XLFormOptionObject

// 显示在页面上的是城市中文名
// 如果对象遵守 XLFormOptionObject 协议，XLForm 从 formDisplayText 方法中得到要显示的值。
- (NSString *)formDisplayText {
    return [NSString stringWithFormat:@"%@，%@",_currentProvince.name, _currentCity.name];
}

// 提交时传的参数是城市代码
- (id)formValue {
    return @{
        @"province":_currentProvince.code,
        @"city":_currentCity.code
    };
}

@end
