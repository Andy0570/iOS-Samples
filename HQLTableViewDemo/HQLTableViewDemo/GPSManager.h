//
//  GPSManager.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/20.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Placemark.h"

NS_ASSUME_NONNULL_BEGIN

// 反向编码，回调经纬度的 Block
typedef void(^GPSCoorClosure)(CLLocationDegrees latitude, CLLocationDegrees longitude);
// 反向编码，回调地址信息的 Block
typedef void(^GPSPlacemarkClosure)(Placemark *placemark);

@interface GPSManager : NSObject

/// 定位回调
+ (void)getGPSLocation:(GPSCoorClosure)closure;

/// 停止定位
+ (void)stop;

/// 是否启用定位服务
+ (BOOL)locationServicesEnabled;

/// 反向地理编码获取地址信息，经纬度字符串 -> Placemark
+ (void)getPlacemarkWithLatitude:(NSString *)latitude longitude:(NSString *)longitude closure:(GPSPlacemarkClosure)closure;

/// 反向地理编码获取地址信息，CLLocationCoordinate2D -> Placemark
+ (void)getPlacemarkWithCoordinate2D:(CLLocationCoordinate2D)coor closure:(GPSPlacemarkClosure)closure;

/// 地理编码获取经纬度，NSString -> (latitude, longitude)
+ (void)getGPSLocationWithAddress:(NSString *)address closure:(GPSCoorClosure)closure;

@end

NS_ASSUME_NONNULL_END
