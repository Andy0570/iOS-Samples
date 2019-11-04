//
//  ScaryBugs+CoreDataProperties.m
//  
//
//  Created by Qilin Hu on 2018/1/3.
//
//

#import "ScaryBugs+CoreDataProperties.h"

@implementation ScaryBugs (CoreDataProperties)

+ (NSFetchRequest<ScaryBugs *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ScaryBugs"];
}

@dynamic title;
@dynamic rating;

@end
