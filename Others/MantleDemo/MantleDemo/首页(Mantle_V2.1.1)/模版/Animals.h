//
//  Animals.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>
@class Dog;

typedef NS_ENUM(char, AnimalState) {
    AnimalStateA,
    AnimalStateB,
    AnimalStateC
};

NS_ASSUME_NONNULL_BEGIN

@interface Animals : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSNumber *typeID;
@property (nonatomic, copy, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSArray *imagesArray; // Array<NSURL>
@property (nonatomic, copy, readonly) NSArray *dogsArray;   // Array<Dog>
@property (nonatomic, assign, readonly) AnimalState state;  // 枚举类型
@property (nonatomic, strong, readonly) Dog *dog; // 包含其他模型

@property (nonatomic, copy, readonly) NSString *notes;

@end

NS_ASSUME_NONNULL_END
