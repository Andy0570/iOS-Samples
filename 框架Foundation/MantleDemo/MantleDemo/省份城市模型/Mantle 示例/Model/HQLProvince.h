//
//  HQLProvince.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/7/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>
@class HQLCity;

NS_ASSUME_NONNULL_BEGIN

// 省级模型
@interface HQLProvince : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *code;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSArray<HQLCity *> *children;

@end

NS_ASSUME_NONNULL_END
