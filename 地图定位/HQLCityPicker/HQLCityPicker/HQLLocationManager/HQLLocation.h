//
//  HQLLocation.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/30.
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
