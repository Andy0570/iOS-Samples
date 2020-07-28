//
//  CitiesDataTool.h
//  ChooseLocation
//
//  Created by Sekorm on 16/10/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 该工具类的作用是，查询模型，返回所需的信息
@interface CitiesDataTool : NSObject

+ (instancetype)sharedManager;

- (void)requestGetData;

// 查询出所有的省
- (NSMutableArray *)queryAllProvince;

// 根据areaLevel级别,省ID(sheng)  ,查询 市
- (NSMutableArray *)queryAllRecordWithShengID:(NSString *)sheng;

// 根据areaLevel级别，省ID(sheng)，市ID(di)，查询 县
- (NSMutableArray *)queryAllRecordWithShengID:(NSString *)sheng cityID:(NSString *)di;

// 根据 areaCode, 查询地址
- (NSString *)queryAllRecordWithAreaCode:(NSString *)areaCode;

@end
