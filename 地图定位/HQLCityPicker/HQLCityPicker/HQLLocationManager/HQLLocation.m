//
//  HQLLocation.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/30.
//

#import "HQLLocation.h"

@implementation HQLLocation

- (instancetype)initWithLongitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude {
    self = [super init];
    if (!self) { return nil; }
    
    _longitude = longitude;
    _latitude = latitude;
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:HQLLocation.class];
}

@end
