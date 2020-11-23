//
//  HPUser.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2018/1/9.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 生成器模式
 
 需要引入外部类进行管理。生成器有setter方法，也需要提供与模型数据完全一致的存储。生成器最终也会使用初始化器。
 
 “Any problem  in computer science can be solved by anther layer of indirection.”
 “计算机科学领域的任何问题都可以通过增加一个间接的中间层来解决”
 
 */
@class HPUserBuilder;
@class HPUser;

typedef void(^HPUserBuilderBlock)(HPUserBuilder *builder);

@interface HPUserBuilder : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSDate *dateOfBirth;

- (HPUser *)build;
- (HPUserBuilder *)username:(NSString *)username;
- (HPUserBuilder *)gender:(NSString *)gender;
- (HPUserBuilder *)dateOfBirth:(NSDate *)dateOfBirth;

@end

@interface HPUser : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSDate *dateOfBirth;

- (instancetype)initWithBuilder:(HPUserBuilder *)builder;
- (instancetype)initWithBlock:(HPUserBuilderBlock)block;

@end
