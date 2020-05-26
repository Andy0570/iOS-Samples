//
//  BNRPerson.h
//  BMITime
//
//  Created by ToninTech on 2017/3/20.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

/*
 *  BNRPerson.h 称为 头文件／接口文件，包含实例变量和方法的声明。
 *
 */
#import <Foundation/Foundation.h>

@interface BNRPerson : NSObject

// BNRPerson 类有两个属性
// 声明属性的时候，编译器不仅会帮你声明存取方法，还会根据属性的声明实现存取方法。
@property (nonatomic) float heightInMeters;
@property (nonatomic) int weightInkilos;

/*
{
 
    // BNRPerson 类拥有两个实例变量
    float _heightInMeters;
    int _weightInkilos;
 
}

 */

/*
 
// BNRPerson 类拥有可以读取并设置实例变量的方法
- (float)heightInMeters;
- (void)setHeightInMeters:(float)h;
- (int)weightInKilos;
- (void)setWeightInKilos:(int)w;
// BNRPerson 类拥有计算 Body Mass Index 的方法
 
 */

- (float)bodyMassIndex;
 


@end
