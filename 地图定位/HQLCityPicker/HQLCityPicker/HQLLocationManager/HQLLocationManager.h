//
//  HQLLocationManager.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/30.
//

#import <Foundation/Foundation.h>
@class HQLLocation, HQLCity;

NS_ASSUME_NONNULL_BEGIN

typedef void(^HQLLocationRequestBlock)(HQLCity *currentCity, HQLLocation *currentLocation);

/// 定位管理器
@interface HQLLocationManager : NSObject

// HQLCity 的便捷属性，供外部调用
@property (nonatomic, readonly, copy) NSString *cityCode;
@property (nonatomic, readonly, copy) NSString *cityName;

// HQLLocation 的便捷属性，供外部调用
@property (nonatomic, readonly, strong) NSNumber *longitude;
@property (nonatomic, readonly, strong) NSNumber *latitude;

+ (instancetype)sharedManager;

/// 获取当前定位信息
/// @param block 返回 GPS 坐标经纬度和所在的城市
- (void)requestLocationWithCompletionHandler:(HQLLocationRequestBlock)block;

@end

NS_ASSUME_NONNULL_END
