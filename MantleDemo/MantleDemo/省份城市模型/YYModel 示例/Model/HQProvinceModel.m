//
//  HQProvinceModel.m
//  XLForm
//
//  Created by Qilin Hu on 2018/1/31.
//  Copyright © 2018年 Xmartlabs. All rights reserved.
//

#import "HQProvinceModel.h"
#import <YYKit.h>

@interface HQCityModel ()

@property (nonatomic, copy, readwrite) NSString *cityId;
@property (nonatomic, copy, readwrite) NSString *cityName;

@end

@implementation HQCityModel

@end

@interface HQProvinceModel ()

@property (nonatomic, copy, readwrite) NSString *provinceId;
@property (nonatomic, copy, readwrite) NSString *provinceName;
@property (nonatomic, copy, readwrite) NSArray *city; 

@end

@implementation HQProvinceModel

#pragma mark - Private

// 返回容器类中的所需要存放的数据类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"city":[HQCityModel class]};
}

#pragma mark - Description

- (NSString *)description {
    return [self modelDescription];
}

@end
