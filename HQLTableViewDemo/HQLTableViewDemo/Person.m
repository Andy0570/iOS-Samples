//
//  Person.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/30.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)setName:(NSString *)name age:(NSInteger)age {
    self.name = name;
    self.age = age;
}

#pragma mark - NSCoding

// 1.编码方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"PersonName"];
    [aCoder encodeInteger:self.age forKey:@"PersonAge"];
}

// 2.解码方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"PersonName"];
        self.age = [aDecoder decodeIntegerForKey:@"PersonAge"];
    }
    return self;
}

@end




