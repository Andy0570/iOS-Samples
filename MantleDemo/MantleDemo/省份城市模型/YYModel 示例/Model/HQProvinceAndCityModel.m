//
//  HQProvinceAndCityModel.m
//  XLForm
//
//  Created by Qilin Hu on 2018/2/1.
//  Copyright © 2018年 Xmartlabs. All rights reserved.
//

#import "HQProvinceAndCityModel.h"

@interface HQProvinceAndCityModel ()

@property (nonatomic, copy, readwrite) NSString *provinceId;
@property (nonatomic, copy, readwrite) NSString *provinceName;
@property (nonatomic, copy, readwrite) NSString *cityId;
@property (nonatomic, copy, readwrite) NSString *cityName;

@end

@implementation HQProvinceAndCityModel

#pragma mark - Init

- (instancetype)initWithProvinceId:(NSString *)provinceId
                      ProvinceName:(NSString *)provinceName
                            CityId:(NSString *)cityId
                          CityName:(NSString *)cityName {
    self = [super init];
    if (self) {
        _provinceId   = [provinceId copy];
        _provinceName = [provinceName copy];
        _cityId       = [cityId copy];
        _cityName     = [cityName copy];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Method Undefined"
                                   reason:@"Use Designated Initializer Method"
                                 userInfo:nil];
    return nil;
}

#pragma mark - XLFormOptionObject

// 显示在页面上的是城市中文名
// 如果对象遵守 XLFormOptionObject 协议，XLForm 从 formDisplayText  方法中得到要显示的值。
- (NSString *)formDisplayText {
    return [NSString stringWithFormat:@"%@，%@",_provinceName,_cityName];
}

// 提交时传的参数是城市代码
- (id)formValue {
    return @{@"province":_provinceId,
             @"city":_cityId};
}

@end
