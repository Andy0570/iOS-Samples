//
//  HQLLocation.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//  Released under an MIT license: http://opensource.org/licenses/MIT
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
