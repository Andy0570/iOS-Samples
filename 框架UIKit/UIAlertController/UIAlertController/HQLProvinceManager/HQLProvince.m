//
//  HQLProvince.m
//  XLForm
//
//  Created by Qilin Hu on 2020/11/26.
//  Copyright © 2020 Xmartlabs. All rights reserved.
//

#import "HQLProvince.h"

@implementation HQLArea

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"code" : @"code",
        @"name" : @"name"
    };
}

@end

@implementation HQLCity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"code"       : @"code",
        @"name"       : @"name",
        @"children"   : @"children",
        @"area"       : @"area",
        @"first_char" : @"first_char",
        @"ID"         : @"id",
        @"listorder"  : @"listorder",
        @"parentid"   : @"parentid",
        @"pinyin"     : @"pinyin",
        @"region"     : @"region"
    };
}

// children
// MARK: JSON Array <——> NSArray<Model>
+ (NSValueTransformer *)childrenJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:HQLArea.class];
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
// MARK: JSON Array <——> NSArray<Model>
+ (NSValueTransformer *)childrenJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:HQLCity.class];
}

@end
