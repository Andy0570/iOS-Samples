//
//  HQLLocationManager.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "HQLLocationManager.h"

// Framework
#import <INTULocationManager/INTULocationManager.h>
#import <UIKit/UIKit.h>

// Model
#import "HQLProvince.h"
#import "HQLLocation.h"

// Utils
#import "HQLPropertyListStore.h"

// 城市定位信息，默认定位，无锡市
static NSString *const kDefaultCityCode = @"320200";
static NSString *const kDefaultCityName = @"无锡市";
static const CGFloat kDefaultLongitude = 120.301663;
static const CGFloat kDefaultLatitude = 31.574729;

static NSString * const kJSONFileName = @"City.json";
static HQLLocationManager *_sharedLocationManager = nil;

@interface HQLLocationManager ()
@property (nonatomic, readwrite, copy) NSArray<HQLCity *> *cities;
@property (nonatomic, readwrite, strong) HQLCity *currentCity;
@property (nonatomic, readwrite, strong) HQLLocation *currentLocation;
@end

@implementation HQLLocationManager

#pragma mark - Initialize

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManager = [[self alloc] init];
    });
    return _sharedLocationManager;
}

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    [self loadCityData];
    return self;
}

// 加载城市数据
- (void)loadCityData {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        HQLPropertyListStore *cityStore = [[HQLPropertyListStore alloc] initWithJSONFileName:kJSONFileName modelsOfClass:[HQLCity class]];
        self.cities = cityStore.dataSourceArray;
    });
}

#pragma mark - Custom Accessors

- (NSString *)cityCode {
    if (_currentCity.code.length > 0) {
        return _currentCity.code;
    } else {
        return kDefaultCityCode;
    }
}

- (NSString *)cityName {
    if (_currentCity.name.length > 0) {
        return _currentCity.name;
    } else {
        return kDefaultCityName;
    }
}

- (NSNumber *)longitude {
    if (_currentLocation.longitude) {
        return _currentLocation.longitude;
    } else {
        return [NSNumber numberWithFloat:kDefaultLongitude];
    }
}

- (NSNumber *)latitude {
    if (_currentLocation.latitude) {
        return _currentLocation.latitude;
    } else {
        return [NSNumber numberWithFloat:kDefaultLatitude];
    }
}

#pragma mark - Public

- (void)requestLocationWithCompletionHandler:(HQLLocationRequestBlock)block {
    // 1.通过 INTULocationManager 获得设备 GPS 坐标
    __weak __typeof(self)weakSelf = self;
    INTULocationManager *locationManager = [INTULocationManager sharedInstance];
    [locationManager requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:10.0 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (status == INTULocationStatusSuccess) {
            // 保存经纬度坐标
            CLLocationCoordinate2D coordinate = currentLocation.coordinate;
            HQLLocation *location = [[HQLLocation alloc] initWithLongitude:[NSNumber numberWithDouble:coordinate.longitude]
                                                                  Latitude:[NSNumber numberWithDouble:coordinate.latitude]];
            strongSelf.currentLocation = location;
            
            // 2.反地理编码：通过 GPS 坐标获得省份城市名称
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                
                CLPlacemark *currentPlacemark = placemarks.lastObject;
                // 四个直辖市的城市信息无法通过 locality 属性获得
                NSString *currentCity = currentPlacemark.locality ? : currentPlacemark.administrativeArea;
                
                if (currentCity.length > 0) {
                    
                    // 3.通过城市名称获得城市模型
                    // 因为 API 接口需要上传城市所对应的 6 位数值的 code 编码值，因此这里加载 City.json 数据，并遍历返回对应的 HQLCity 模型
                    [strongSelf.cities enumerateObjectsUsingBlock:^(HQLCity *city, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([city.name hasPrefix:currentCity]) {
                            
                            strongSelf.currentCity = city;
                            block(city, location);
                            *stop = YES;
                        }
                    }];
                }
            }];
        }
    }];
}

@end
