//
//  HQLUser.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2018/1/9.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自定义初始化器
 
 缺点：
 1. 如果类包含的属性很多，指定初始化方法的方法名会很长；
 2. 向下兼容问题：如果新增一个属性，新版模型无法实现向下兼容；
 */
@interface HQLUser : NSObject

// 属性的设置：向外层暴露的属性尽量设置为不可变(immutable)、只读（readonly） 
@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *gender;
@property (nonatomic, copy, readonly) NSDate *dateOfBirth;
@property (nonatomic, copy, readonly) NSArray *albums;

// 指定初始化方法
- (instancetype)initWithUserID:(NSString *)userID
                     firstName:(NSString *)firstName
                      lastName:(NSString *)lastName
                        gender:(NSString *)gender
                   dateOfBirth:(NSDate *)dateOfBirth
                        albums:(NSArray *)albums;

@end
