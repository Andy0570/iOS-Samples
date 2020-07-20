//
//  Placemark.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/20.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/// 地标数据模型，针对本地化字体显示作了优化
@interface Placemark : NSObject

@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *address; // 街道地址
@property (nonatomic, assign) int placemarkId;
@property (nonatomic, copy) NSString *type;

+ (Placemark *)initWithCLPlacemark:(CLPlacemark *)placemark;

// 仅返回省份、城市
- (NSString *)getProvinceAndCity;

@end

NS_ASSUME_NONNULL_END

/**
 CLPlacemark 是进行 GEO 编码后返回的地标对象
 
 // 初始化方法 使用另一个placemark拷贝
 - (instancetype)initWithPlacemark:(CLPlacemark *) placemark;
 // 位置信息
 @property (nonatomic, readonly, copy, nullable) CLLocation *location;
 // 区域范围信息
 @property (nonatomic, readonly, copy, nullable) CLRegion *region;
 // 时区
 @property (nonatomic, readonly, copy, nullable) NSTimeZone *timeZone;
 // 地理信息字典
 @property (nonatomic, readonly, copy, nullable) NSDictionary *addressDictionary;
 // 地标名字
 @property (nonatomic, readonly, copy, nullable) NSString *name;
 // 街道名字
 @property (nonatomic, readonly, copy, nullable) NSString *thoroughfare;
 // 子街道名字
 @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare;
 // 城镇
 @property (nonatomic, readonly, copy, nullable) NSString *locality;
 // 子城镇
 @property (nonatomic, readonly, copy, nullable) NSString *subLocality;
 // 州域信息
 @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea;
 // 子州域信息
 @property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea;
 // 邮编
 @property (nonatomic, readonly, copy, nullable) NSString *postalCode;
 // ISO国家编码
 @property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode;
 // 国家
 @property (nonatomic, readonly, copy, nullable) NSString *country;
 // 水域名称
 @property (nonatomic, readonly, copy, nullable) NSString *inlandWater;
 // 海洋名称
 @property (nonatomic, readonly, copy, nullable) NSString *ocean;
 // 相关的兴趣点数组
 @property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *areasOfInterest;
 
 */
