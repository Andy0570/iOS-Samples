//
//  HQLPropertyListStore.h
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2020/11/7.
//  Copyright © 2020 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Store 类，加载本地 Property List 数据，JSON 数据
 
 !!!: 内部使用 <Mantle> 框架实现 JSON 与模型之间的相互转换
 */
@interface HQLPropertyListStore : NSObject

@property (nonatomic, readonly, copy) NSArray *dataSourceArray;

- (instancetype)initWithPlistFileName:(NSString *)fileName modelsOfClass:(Class)modelClass;

- (instancetype)initWithJSONFileName:(NSString *)fileName modelsOfClass:(Class)modelClass;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
