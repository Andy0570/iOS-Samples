//
//  XYUser.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/5/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYHelper : MTLModel <MTLJSONSerializing>

@property (readwrite, nonatomic, copy) NSString *name;
@property (readwrite, nonatomic, strong) NSDate *createdAt;

+ (instancetype)helperWithName:(NSString *)name createdAt:(NSDate *)createdAt;

@end

@interface XYUser : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, strong) NSDate *createdAt;

@property (readonly, nonatomic, assign, getter = isMeUser) BOOL meUser;
@property (readonly, nonatomic, strong) XYHelper *helper;

@end

NS_ASSUME_NONNULL_END
