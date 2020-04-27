//
//  Dog.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSNumber *typeID;

@end

NS_ASSUME_NONNULL_END
