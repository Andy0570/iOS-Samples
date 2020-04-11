//
//  HQLTableViewCellGroupedModel.m
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/4/2.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "HQLTableViewCellGroupedModel.h"
#import "HQLTableViewCellStyleDefaultModel.h"

@implementation HQLTableViewCellGroupedModel

#pragma mark - Private

// 返回容器类中的所需要存放的数据类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cells":[HQLTableViewCellStyleDefaultModel class]};
}

#pragma mark - Description

- (NSString *)description {
    return [self modelDescription];
}


@end
