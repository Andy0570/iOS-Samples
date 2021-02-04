//
//  HQLProvince.m
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/29.
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
