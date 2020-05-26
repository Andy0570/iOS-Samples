//
//  BNRPerson.m
//  BMITime
//
//  Created by ToninTech on 2017/3/20.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

/*
 *  BNRPerson.m 称为 实现文件，包含所有方法的代码实现。
 *
 */

#import "BNRPerson.h"

@implementation BNRPerson

/*
// BNRPerson 类拥有可以读取并设置实例变量的方法
- (float)heightInMeters {
    return _heightInMeters;
}

- (void)setHeightInMeters:(float)h {
    _heightInMeters = h;
}

- (int)weightInKilos {
    return _weightInkilos;
}

- (void)setWeightInKilos:(int)w {
    _weightInkilos = w;
}

 */
// BNRPerson 类拥有计算 Body Mass Index 的方法
- (float)bodyMassIndex {
    
//    return _weightInkilos / (_heightInMeters * _heightInMeters);
    
    // 使用存取方法访问实例变量
    // self 是指针，指向运行当前方法的对象
    float h = [self heightInMeters];
    return [self weightInkilos] / (h * h);
}

@end
