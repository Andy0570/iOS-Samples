//
//  HQLGovermentModel.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/12.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLGovermentModel.h"
#import <YYKit.h>

@implementation ListData

#pragma mark NSObject

- (NSString *)description {
    return [self modelDescription];
}

@end

#pragma mark -

@implementation ResultData

#pragma mark Private
// ❇️ 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [ListData class]};
}

#pragma mark NSObject

- (NSString *)description {
    return [self modelDescription];
}

@end

#pragma mark -

@implementation HQLGovermentModel

#pragma mark NSObject

- (NSString *)description {
    return [self modelDescription];
}

@end
