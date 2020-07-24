//
//  HQLPropertyListStore.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/7/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Store 类，加载本地 Property List 数据、JSON 数据
@interface HQLPropertyListStore : NSObject

@property (nonatomic, readonly, copy) NSArray *dataSourceArray;

- (instancetype)initWithPlistFileName:(NSString *)fileName modelsOfClass:(Class)modelClass;

- (instancetype)initWithJSONFileName:(NSString *)fileName modelsOfClass:(Class)modelClass;

@end

NS_ASSUME_NONNULL_END
