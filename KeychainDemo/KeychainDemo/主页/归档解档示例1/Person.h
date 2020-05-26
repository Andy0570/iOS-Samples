//
//  Person.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/30.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger age;

- (void)setName:(NSString *)name age:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
