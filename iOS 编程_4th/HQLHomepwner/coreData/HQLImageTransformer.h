//
//  HQLImageTransformer.h
//  HQLHomepwner
//
//  Created by ToninTech on 2017/5/24.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 向 Core Data 描述转换过程
 
 将 thumbnail 声明为 Core Data 可以存储的 transformable 类型。
 Core Data 会在存储或恢复 transformable 类型的实体属性时首先将其转换为 NSData，然后再存入文件系统或恢复为 Objective-C 对象。
 */
@interface HQLImageTransformer : NSValueTransformer

@end
