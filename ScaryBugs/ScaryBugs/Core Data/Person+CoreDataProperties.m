//
//  Person+CoreDataProperties.m
//  ScaryBugs
//
//  Created by Qilin Hu on 2018/1/3.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic name;
@dynamic age;

@end
