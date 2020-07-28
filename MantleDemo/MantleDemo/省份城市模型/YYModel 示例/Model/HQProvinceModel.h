//
//  HQProvinceModel.h
//  XLForm
//
//  Created by Qilin Hu on 2018/1/31.
//  Copyright © 2018年 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

// 数据源模型

// 城市模型
@interface HQCityModel : NSObject

@property (nonatomic, copy, readonly) NSString *cityId;
@property (nonatomic, copy, readonly) NSString *cityName;

@end

// 省级模型
@interface HQProvinceModel : NSObject

@property (nonatomic, copy, readonly) NSString *provinceId;
@property (nonatomic, copy, readonly) NSString *provinceName;
@property (nonatomic, copy, readonly) NSArray *city; // NSArray<HQCityModel>

@end
