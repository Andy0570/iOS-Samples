//
//  Item+CoreDataProperties.m
//  HQLHomepwner
//
//  Created by ToninTech on 2017/5/25.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item"];
}

@dynamic dateCreated;
@dynamic itemKey;
@dynamic itemName;
@dynamic orderingValue;
@dynamic serialNumber;
@dynamic thumbnail;
@dynamic valueInDollars;
@dynamic assetType;

@end
