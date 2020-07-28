//
//  HQLCity.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/7/22.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCity.h"

@implementation HQLCity

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"area"       : @"area",
        @"code"       : @"code",
        @"first_char" : @"first_char",
        @"ID"         : @"id",
        @"listorder"  : @"listorder",
        @"name"       : @"name",
        @"parentid"   : @"parentid",
        @"pinyin"     : @"pinyin",
        @"region"     : @"region"
    };
}

@end
