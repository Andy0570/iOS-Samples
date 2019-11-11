//
//  Item+CoreDataProperties.h
//  HQLHomepwner
//
//  Created by ToninTech on 2017/5/25.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateCreated;
@property (nullable, nonatomic, copy) NSString *itemKey;
@property (nullable, nonatomic, copy) NSString *itemName;
@property (nonatomic) double orderingValue;
@property (nullable, nonatomic, copy) NSString *serialNumber;
@property (nullable, nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) int valueInDollars;
@property (nullable, nonatomic, retain) HQLAssetType *assetType;

@end

NS_ASSUME_NONNULL_END
