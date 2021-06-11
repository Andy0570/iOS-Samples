//
//  HQLProvinceManager.m
//  XLForm
//
//  Created by Qilin Hu on 2020/11/26.
//  Copyright © 2020 Xmartlabs. All rights reserved.
//

#import "HQLProvinceManager.h"
#import "HQLPropertyListStore.h"
#import "HQLProvince.h"

static NSString * const kJSONFileName = @"pca-code.json";
static HQLProvinceManager *_sharedManager = nil;

@interface HQLProvinceManager ()
@property (nonatomic, readwrite, copy) NSArray<HQLProvince *> *provinces;
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

#pragma mark - Custom Accessors

// 设置当前省份时，更新当前城市区域
- (void)setCurrentProvince:(HQLProvince *)currentProvince {
    _currentProvince = currentProvince;
    self.currentCity = currentProvince.children.firstObject;
}

- (void)setCurrentCity:(HQLCity *)currentCity {
    _currentCity = currentCity;
    self.currentArea = self.currentCity.children.firstObject;
}

#pragma mark - Public

- (void)setCurrentCityName:(NSString *)name {
    if (!name || [name isEqualToString:@""]) { return; }
    
    // 根据当前城市名称，找到所属省份
    [self.provinces enumerateObjectsUsingBlock:^(HQLProvince *currentProvince, NSUInteger idx, BOOL * _Nonnull stop) {
        [currentProvince.children enumerateObjectsUsingBlock:^(HQLCity *currentCity, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([currentCity.name isEqualToString:name]) {
                self.currentProvince = currentProvince;
                self.currentCity = currentCity;
                self.currentArea = self.currentCity.children.firstObject;
                *stop = YES;
            }
        }];
    }];
}

- (void)setCurrentCityCode:(NSString *)code {
    if (!code || [code isEqualToString:@""]) { return; }
    
    // 根据当前城市代码找到所属省份
    [self.provinces enumerateObjectsUsingBlock:^(HQLProvince *currentProvince, NSUInteger idx, BOOL * _Nonnull stop) {
        [currentProvince.children enumerateObjectsUsingBlock:^(HQLCity *currentCity, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([currentCity.code isEqualToString:code]) {
                self.currentProvince = currentProvince;
                self.currentCity = currentCity;
                self.currentArea = self.currentCity.children.firstObject;
                *stop = YES;
            }
        }];
    }];
}

#pragma mark - Private

- (void)loadProvinceData {
    HQLPropertyListStore *store = [[HQLPropertyListStore alloc] initWithJSONFileName:kJSONFileName modelsOfClass:HQLProvince.class];
    self.provinces = store.dataSourceArray;
    
    // 初始化并设置默认省份城市
    self.currentProvince = self.provinces.firstObject;
    self.currentCity = self.currentProvince.children.firstObject;
    self.currentArea = self.currentCity.children.firstObject;
}

@end
