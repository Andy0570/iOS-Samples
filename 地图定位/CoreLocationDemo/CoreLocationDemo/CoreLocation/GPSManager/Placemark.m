//
//  Placemark.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/20.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import "Placemark.h"

@implementation Placemark

#pragma mark - Initialize

+ (Placemark *)initWithCLPlacemark:(CLPlacemark *)placemark {
    Placemark *mark = [[Placemark alloc] init];
    mark.country = placemark.country ? : @"";
    mark.province = placemark.administrativeArea ? : @"";
    mark.city = placemark.locality ? : @"";
    mark.county = placemark.subLocality ? : @"";
    NSString *formatAddress = [NSString stringWithFormat:@"%@%@", placemark.thoroughfare ? placemark.thoroughfare : @"",
    placemark.subThoroughfare ? placemark.subThoroughfare:@""];
    mark.address = formatAddress;
    return mark;
}

#pragma mark - Custom Accessors

- (NSString *)province {
    NSString *provinceName = _province;
    if ([provinceName hasSuffix:@"省"]) {
        provinceName = [provinceName substringToIndex:[provinceName length] - 1];
    } else if ([provinceName hasSuffix:@"市"]) {
        provinceName = [provinceName substringToIndex:[provinceName length] - 1];
    }
    return provinceName;
}

- (NSString *)city {
    NSString *cityName = _city;
    if ([cityName hasSuffix:@"市辖区"]) {
        cityName = [cityName substringToIndex:[cityName length] - 3];
    } else if ([cityName hasSuffix:@"市"]) {
        cityName = [cityName substringToIndex:[cityName length] - 1];
    } else if ([cityName isEqualToString:@"香港特別行政區"] || [cityName isEqualToString:@"香港特别行政区"]) {
        cityName = @"香港";
    } else if ([cityName isEqualToString:@"澳門特別行政區"] || [cityName isEqualToString:@"澳门特别行政区"]) {
        cityName = @"澳门";
    }
    
    return cityName;
}

#pragma mark - Public

// 仅返回省份、城市
- (NSString *)getProvinceAndCity {
    if ([self.city isEqualToString:self.province]) {
        self.province = @"";
    } else if ([self.city hasSuffix:@"市辖区"]) {
        self.city = [self.city substringToIndex:[self.city length] - 3];
    } else if ([self.city isEqualToString:@"香港特別行政區"] || [self.city isEqualToString:@"香港特别行政区"]) {
        self.city = @"香港";
    } else if ([self.city isEqualToString:@"澳門特別行政區"] || [self.city isEqualToString:@"澳门特别行政区"]) {
        self.city = @"澳门";
    }
    return [self.province stringByAppendingString:self.city];
}

#pragma mark - Copy

- (id)mutableCopyWithZone:(NSZone *)zone {
    Placemark *copy = [[[self class] allocWithZone:zone] init];
    copy->_country = [self.country mutableCopy];
    copy->_province = [self.province mutableCopy];
    copy->_city = [self.city mutableCopy];
    copy->_county = [self.county mutableCopy];
    copy->_address = [self.address mutableCopy];
    copy->_placemarkId = self.placemarkId;
    copy->_type = [self.type mutableCopy];
    return copy;
}

- (id)copyWithZone:(NSZone *)zone {
    Placemark *copy = [[[self class] allocWithZone:zone] init];
    copy->_country = [self.country copy];
    copy->_province = [self.province copy];
    copy->_city = [self.city copy];
    copy->_county = [self.county copy];
    copy->_address = [self.address copy];
    copy->_placemarkId = self.placemarkId;
    copy->_type = [self.type copy];
    return copy;
}

@end
