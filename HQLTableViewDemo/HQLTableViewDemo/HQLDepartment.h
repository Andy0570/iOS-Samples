//
//  HQLDepartment.h
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/21.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HQLRightDepartment;

/**
 【预约挂号】- 科室数据模型
 */
@interface HQLDepartment : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray  *rightDepartments; // Array<HQLRightDepartment>

@end
