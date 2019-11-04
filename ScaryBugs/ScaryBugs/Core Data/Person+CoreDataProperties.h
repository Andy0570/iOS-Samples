//
//  Person+CoreDataProperties.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2018/1/3.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

// Xcode 自动创建的 NSManagedObject 会生成 fetchRequest 方法，可以直接得到 NSFetchRequest 对象
+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t age;

@end

NS_ASSUME_NONNULL_END
