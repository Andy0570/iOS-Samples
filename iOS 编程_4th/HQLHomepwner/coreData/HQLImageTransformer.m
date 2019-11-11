//
//  HQLImageTransformer.m
//  HQLHomepwner
//
//  Created by ToninTech on 2017/5/24.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLImageTransformer.h"

@implementation HQLImageTransformer

+ (Class) transformedValueClass {
    return [NSData class];
}

//  存储：UIImage → NSData
- (id) transformedValue:(id)value {
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    return UIImagePNGRepresentation(value);
}

// 恢复：NSData → UIImage
- (id) reverseTransformedValue:(id)value {
    return [UIImage imageWithData:value];
}

@end
