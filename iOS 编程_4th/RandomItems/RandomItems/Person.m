//
//  Person.m
//  RandomItems
//
//  Created by Qilin Hu on 2019/11/7.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "Person.h"

@implementation Person

// 为 lastNameOfSpouse 属性自定义存取方法
// 由于同时覆盖了存方法和取方法，编译器不会自动再为 lastNameOfSpouse 生成实例变量。
- (void)setLastNameOfSpouse:(NSString *)lastNameOfSpouse {
    self.spouse.lastNamel = lastNameOfSpouse;
}

- (NSString *)lastNameOfSpouse {
    return self.spouse.lastNamel;
}

@end
