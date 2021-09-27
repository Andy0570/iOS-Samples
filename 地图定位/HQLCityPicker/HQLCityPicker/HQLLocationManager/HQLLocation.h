//
//  HQLLocation.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/// GPS 坐标模型
@interface HQLLocation : MTLModel <MTLJSONSerializing>

@property (nonatomic, readwrite, strong) NSNumber *longitude; // 经度
@property (nonatomic, readwrite, strong) NSNumber *latitude;  // 纬度

- (instancetype)initWithLongitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude;

@end

NS_ASSUME_NONNULL_END
