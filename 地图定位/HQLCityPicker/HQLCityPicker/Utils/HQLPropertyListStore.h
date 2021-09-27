//
//  HQLPropertyListStore.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Store 类，加载本地 Property List 数据、JSON 数据。
 将 JSON Array 文件转换为 NSArray<NSObject> 模型。
 
 !!!: 内部使用 <Mantle> 框架实现 JSON 与模型之间的相互转换
 */
@interface HQLPropertyListStore : NSObject

@property (nonatomic, readonly, copy) NSArray *dataSourceArray;

- (instancetype)initWithPlistFileName:(NSString *)fileName modelsOfClass:(Class)modelClass;
- (instancetype)initWithJSONFileName:(NSString *)fileName modelsOfClass:(Class)modelClass;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
