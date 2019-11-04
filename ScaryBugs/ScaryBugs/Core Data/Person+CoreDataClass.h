//
//  Person+CoreDataClass.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2018/1/3.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Person+CoreDataProperties.h"


/**
 Core Data 堆栈的介绍与使用
 
 * NSManagedObjectModel：数据模型的结构信息
 * NSPersistentStoreCoordinator 数据持久层和对象模型协调器
 * NSManagedObjectContext 对象的上下文 managedObject 模型
 
 
 
 
 */
