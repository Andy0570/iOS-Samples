//
//  HQLProvinceManager.h
//  XLForm
//
//  Created by Qilin Hu on 2020/11/26.
//  Copyright © 2020 Xmartlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HQLProvince;
@class HQLCity;
@class HQLArea;

NS_ASSUME_NONNULL_BEGIN

@interface HQLProvinceManager : NSObject

@property (nonatomic, readonly, copy) NSArray<HQLProvince *> *provinces;

@property (nonatomic, readwrite, strong) HQLProvince *currentProvince;
@property (nonatomic, readwrite, strong) HQLCity *currentCity;
@property (nonatomic, readwrite, strong) HQLArea *currentArea;

+ (instancetype)sharedManager;
- (instancetype)init NS_UNAVAILABLE;

- (void)setCurrentCityName:(NSString *)name;
- (void)setCurrentCityCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
