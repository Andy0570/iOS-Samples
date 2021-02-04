//
//  HQLArchiveBaseModel.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/7.
//

#import "HQLArchiveBaseModel.h"
#import <objc/runtime.h>

@implementation HQLArchiveBaseModel

- (void)encodeWithCoder:(NSCoder *)coder {
    NSArray *names = [[self class] getPropertyNames];
    [names enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = [self valueForKey:propertyName];
        [coder encodeObject:value forKey:propertyName];
    }];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (!self) { return nil; }
    
    NSArray *names = [[self class] getPropertyNames];
    [names enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = [coder decodeObjectForKey:propertyName];
        [self setValue:value forKey:propertyName];
    }];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id obj = [[[self class] alloc] init];
    NSArray *names = [[self class] getPropertyNames];
    [names enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = [self valueForKey:propertyName];
        [obj setValue:value forKey:propertyName];
    }];
    return obj;
}

+ (NSArray *)getPropertyNames {
    // Property count
    unsigned int count;
    // Get property list
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // Get names
    NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        // objc_property_t
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if (name.length) {
            [propertyNames addObject:name];
        }
    }
    free(properties);
    return [propertyNames copy];
}

@end
