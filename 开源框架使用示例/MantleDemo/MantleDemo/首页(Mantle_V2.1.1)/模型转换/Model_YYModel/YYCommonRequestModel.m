//
//  YYCommonRequestModel.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/7/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "YYCommonRequestModel.h"
#import <YYKit.h>

@implementation YYCommonRequestModel


#pragma mark - Override


// 减分项：description 方法需要 override
- (NSString *)description {
    return [self modelDescription];
}

@end
