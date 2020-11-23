//
//  CoreLocationViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/19.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "CoreLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GPSManager.h"

static NSString * const cellReuseIdentifier = @"UITableViewCellStyleDefault";

@interface CoreLocationViewController ()

@property (nonatomic, copy) NSArray<NSString *> *dataSourceArray;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, copy) NSString *address;

@end

@implementation CoreLocationViewController

#pragma mark - Initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - Custom Accessors

- (NSArray <NSString *> *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = @[@"开始定位",
                             @"停止定位",
                             @"地理编码(根据地址获取经纬度)",
                             @"反地理编码(根据经纬度获取地址)",
                             @"单次定位"];
    }
    return _dataSourceArray;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak __typeof(self)weakSelf = self;
    switch (indexPath.row) {
        case 0: {
            // !!!: 开始定位
            [GPSManager getGPSLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                strongSelf.lat = latitude;
                strongSelf.lng = longitude;
                NSLog(@"(%lf,%lf)",latitude,longitude);
            }];
            break;
        }
        case 1: {
            // !!!: 停止定位
            [GPSManager stop];
            NSLog(@"您已经停止定位服务");
            break;
        }
        case 2: {
            // !!!: 地理编码(根据地址获取经纬度)
            if (self.address.length == 0) {
                NSLog(@"地址为空，请先进行定位并执行反向地理编码");
                return;
            }

            [GPSManager getGPSLocationWithAddress:self.address closure:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
                NSLog(@"(%lf,%lf)",latitude,longitude);
            }];
            break;
        }
        case 3: {
            // !!!: 反地理编码(根据经纬度获取地址)
            if (self.lat == 0 && self.lng == 0) {
                NSLog(@"GPS坐标为空，请先进行定位");
                return;
            }
            [GPSManager getPlacemarkWithCoordinate2D:CLLocationCoordinate2DMake(self.lat, self.lng) closure:^(Placemark * _Nonnull placemark) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                strongSelf.address = [NSString stringWithFormat:@"%@%@%@%@%@", placemark.country, placemark.province, placemark.city, placemark.county, placemark.address];
                NSLog(@"%@", strongSelf.address);
            }];
            break;
        }
        case 4: {
            // !!!: 单次定位
            [GPSManager getGPSLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                strongSelf.lat = latitude;
                strongSelf.lng = longitude;
                
                [GPSManager stop];
                NSLog(@"(%lf,%lf)",latitude,longitude);
            }];
            break;
        }
        default:
            break;
    }
    
}




@end
