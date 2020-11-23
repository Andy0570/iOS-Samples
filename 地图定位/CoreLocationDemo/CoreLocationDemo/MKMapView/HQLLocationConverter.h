//
//  HQLLocationConverter.h
//  CoreLocationDemo
//
//  Created by Qilin Hu on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/// 坐标转换
@interface HQLLocationConverter : NSObject

/// 判断当前坐标是否在中国
/// @param location 二维坐标
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

/// 将 WGS-84 转为 GCJ-02 (火星坐标)
/// @param wgsLocation WGS-84 坐标
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLocation;

/// 将 GCJ-02 (火星坐标)转为 WGS-84
/// @param gcjLocation GCJ-02 坐标
+ (CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)gcjLocation;

/// 将 GCJ-02 (火星坐标)转为百度坐标
/// @param gcjLocation GCJ-02 坐标
+ (CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)gcjLocation;

/// 将百度坐标转为 GCJ-02 (火星坐标)
/// @param baiduLocation 百度坐标
+ (CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)baiduLocation;

@end

NS_ASSUME_NONNULL_END
