//
//  BNRItem_V2.h
//  RandomItems
//
//  Created by Qilin Hu on 2019/11/7.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// V1 版本，为每一个实例变量声明并实现一对存取方法
/// V2 版本，使用属性
@interface BNRItem_V2 : NSObject

// 属性
// 注意：属性的名字是实例变量的名字去掉下划线，编译器会根据属性生成实例变量时自动在变量名前面加上下划线。
@property (nonatomic, readwrite, copy) NSString *itemName;
@property (nonatomic, readwrite, copy) NSString *serialNumber;
@property (nonatomic, readwrite) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

// 类方法
+ (instancetype)randomItem;

// 初始化方法（initialization method）：用于初始化类的对象的方法
// BNRItem 类的指定初始化方法
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
