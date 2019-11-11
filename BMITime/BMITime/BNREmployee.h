//
//  BNREmployee.h
//  BMITime
//
//  Created by ToninTech on 2017/3/27.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRPerson.h"
@class BNRAsset;

@interface BNREmployee : BNRPerson

// 在类的头文件中声明属性的时候，其他对象只能看到属性的存取方法
@property (nonatomic) unsigned int employeeID;

@property (nonatomic) NSDate *hireDate;
@property (nonatomic, copy) NSSet *assets; // 属性
@property (nonatomic) NSString *lastName;
@property (nonatomic) BNRPerson *spouse;
@property (nonatomic) NSMutableArray *children;
- (double)yearsOfEmployment;
- (void)addAsset:(BNRAsset *)a;
- (unsigned int)valueOfAssets;

@end
