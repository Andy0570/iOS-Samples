//
//  Person.m
//  TestLinqToObjectiveC
//
//  Created by huqilin on 2025/3/13.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)name age:(NSNumber *)age {
    self = [super init];
    if (!self) { return nil; }
    
    self.name = name;
    self.age = age;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Person: Name=%@, Age=%@", self.name, self.age];
}

@end
