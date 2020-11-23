//
//  HQProvinceAndCityModel.h
//  XLForm
//
//  Created by Qilin Hu on 2018/2/1.
//  Copyright © 2018年 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
// #import <XLForm/XLFormRowDescriptor.h> // <XLFormOptionObject>

/**
 省份城市模型
 */
@interface HQProvinceAndCityModel : NSObject

@property (nonatomic, copy, readonly) NSString *provinceId;
@property (nonatomic, copy, readonly) NSString *provinceName;
@property (nonatomic, copy, readonly) NSString *cityId;
@property (nonatomic, copy, readonly) NSString *cityName;

// 指定初始化方法
- (instancetype)initWithProvinceId:(NSString *)provinceId
                      ProvinceName:(NSString *)provinceName
                            CityId:(NSString *)cityId
                          CityName:(NSString *)cityName;

@end
