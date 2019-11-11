//
//  BNREmployee.m
//  BMITime
//
//  Created by ToninTech on 2017/3/27.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "BNREmployee.h"
#import "BNRAsset.h"

// 类扩展（Class Extensions）
// 类扩展是一组私有的声明，只有类和其类实例才能使用在类扩展中声明的属性、实例变量或方法。
// 子类无法获取父类的类扩展
@interface BNREmployee ()
{
    // 换用 NSMutableSet 对象来实现员工和物品的关系
    NSMutableSet *_assets; // 实例变量
}

@property (nonatomic) unsigned int officeAlarmCode;

@end

@implementation BNREmployee

// 属性的存取方法
- (void)setAssets:(NSArray *)a {
    _assets = [a mutableCopy];
}

- (NSArray *)assets {
    return [_assets copy];
}

- (void)addAsset:(BNRAsset *)a {
    if (!_assets) {
        // 创建数组
        _assets = [[NSMutableSet alloc] init];
    }
    [_assets addObject:a];
    a.holder = self;
}

- (unsigned int)valueOfAssets {
    // 累加物品的销售价值
    unsigned int sum = 0;
    for (BNRAsset *a in _assets) {
        sum += [a resaleValue];
    }
    return sum;
}

- (double)yearsOfEmployment {
    // 是否拥有一个非 nil 的hireDate？
    if (self.hireDate) {
        NSDate *now = [NSDate date];
        // NSTimeInterval 是 double 类型
        NSTimeInterval secs = [now timeIntervalSinceDate:self.hireDate];
        return secs / 31557600.0;   // 每年的秒数
    }else {
        return 0;
    }
}

// 覆盖方法，覆盖方法的时候只能改变方法的实现，而无法改变它的声明方式，方法的名称，返回类型及实参类型等必须保持相同
- (float)bodyMassIndex {
    float normalBMI = [super bodyMassIndex];
    return normalBMI * 0.9;
}

// description:返回一个描述类实例的字符串，默认的 NSObject 实现会以字符串的形式返回该对象在内存上的地址
// 覆盖 description 方法
- (NSString *)description {
    return [NSString stringWithFormat:@"<Employee %u: $%u in assets>",
            self.employeeID,self.valueOfAssets];
}

- (void)dealloc {
    NSLog(@"deallocaing %@",self);
}

@end
