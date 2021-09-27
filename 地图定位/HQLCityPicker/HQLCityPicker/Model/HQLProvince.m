//
//  HQLProvince.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "HQLProvince.h"

@implementation HQLCity

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

@implementation HQLProvince

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"code"     : @"code",
        @"name"     : @"name",
        @"children" : @"children"
    };
}

// children
// MARK: JSON Array <-> NSArray<Model>
+ (NSValueTransformer *)storiesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:HQLCity.class];
}

@end
