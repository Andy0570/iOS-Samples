//
//  HQLProvinceManager.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/7/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
// #import <XLForm/XLFormRowDescriptor.h> // <XLFormOptionObject>
#import "HQLCity.h"
#import "HQLProvince.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQLProvinceManager : NSObject

@property (nonatomic, readonly, copy) NSArray *provinceArray;
@property (nonatomic, readwrite, strong) HQLProvince *currentProvince;
@property (nonatomic, readwrite, strong) HQLCity *currentCity;

+ (instancetype)sharedManager;

- (void)setCurrentCityCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
