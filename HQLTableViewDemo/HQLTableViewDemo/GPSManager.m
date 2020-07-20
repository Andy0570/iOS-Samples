//
//  GPSManager.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/20.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "GPSManager.h"

static GPSManager *_sharedInstance = nil;

@interface GPSManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) GPSCoorClosure coorClosure;

@end

@implementation GPSManager

#pragma mark - Initialize

+ (GPSManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GPSManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 定位精确度
        _locationManager.distanceFilter = 10; // 定位精度，10m
        
        // 兼容iOS8.0版本，申请请求权限，以下两个权限根据系统需求，二选一
        /* Info.plist里面加上2项中的一项
           NSLocationAlwaysUsageDescription      String YES
           NSLocationWhenInUseUsageDescription   String YES
         */
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            // 仅在应用使用期间允许
            [_locationManager requestWhenInUseAuthorization];
        }
        
        /*
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            // 始终允许
            [_locationManager requestAlwaysAuthorization];
        }
        */
        
        // GEO 编码的工具类
        _geocoder = [[CLGeocoder alloc] init];
        
    }
    return self;
}

#pragma mark - Private

/// 定位回调
- (void)getGPS:(GPSCoorClosure)closure {
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    
    _coorClosure = closure;
    // 停止上一次定位
    [_locationManager stopUpdatingLocation];
    // 开始新一次定位
    [_locationManager startUpdatingLocation];
}

/// 停止定位
- (void)stop {
    [_locationManager stopUpdatingLocation];
}

/// 反向地理编码获取地址信息
- (void)getPlacemarkWithCoor:(CLLocationCoordinate2D)coor closure:(GPSPlacemarkClosure)closure {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            // CLPlacemark -> Placemark
            CLPlacemark *placemark = placemarks.lastObject;
            Placemark *mark = [Placemark initWithCLPlacemark:placemark];
            if (closure) {
                closure(mark);
            }
        }
    }];
}

/// 地理编码获取经纬度
- (void)getGPSLocationWithAddress:(NSString *)address closure:(GPSCoorClosure)closure {
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.lastObject;

            if (closure) {
                closure(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            }
        }
    }];
}

#pragma mark - Public

/// 定位回调
+ (void)getGPSLocation:(GPSCoorClosure)closure {
    [[GPSManager sharedInstance] getGPS:closure];
}

/// 停止定位
+ (void)stop {
    [[GPSManager sharedInstance] stop];
}

/// 是否启用定位服务
+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

/// 反向地理编码获取地址信息
+ (void)getPlacemarkWithLatitude:(NSString *)latitude longitude:(NSString *)longitude closure:(GPSPlacemarkClosure)closure {
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    [[GPSManager sharedInstance] getPlacemarkWithCoor:coor closure:closure];
}

/// 反向地理编码获取地址信息
+ (void)getPlacemarkWithCoordinate2D:(CLLocationCoordinate2D)coor closure:(GPSPlacemarkClosure)closure {
    [[GPSManager sharedInstance] getPlacemarkWithCoor:coor closure:closure];
}

/// 地理编码获取经纬度
+ (void)getGPSLocationWithAddress:(NSString *)address closure:(GPSCoorClosure)closure {
    [[GPSManager sharedInstance] getGPSLocationWithAddress:address closure:closure];
}

#pragma mark - <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lng = location.coordinate.longitude;
    
    if (_coorClosure) {
        _coorClosure(lat, lng);
    }
}

// TODO: 如果用户关闭定位服务，弹窗提示
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    } else if (error.code == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

@end
