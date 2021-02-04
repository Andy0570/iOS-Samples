//
//  Person.m
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
//

#import "Person.h"

@implementation Person

- (void)setName:(NSString * _Nonnull)name age:(NSInteger)age {
    self.name = name;
    self.age = age;
}

#pragma mark - <NSCoding>

// 1.编码方法
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

// 2.解码方法
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}

@end
