//
//  BNRItem.h
//  RandomItems
//
//  Created by Qilin Hu on 2019/11/5.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/// BNRItem.h 是头文件（header file）,也称为接口文件（interface file）。
/// 负责声明类的类名、类的父类、每个类的对象都会拥有的实例变量及该类实现的全部方法。
/// 头文件中的声明顺序约定：实例变量、类方法、初始化方法、其他方法
@interface BNRItem : NSObject {
    // 声明类的实例变量，* 代表相应的变量是指针，因此存的是指向该实例变量的内存地址！
    NSString *_itemName;
    NSString *_serialNumber;
    // 对象会直接保存非指针类型的实例变量。
    int _valueInDollars;
    NSDate *_dateCreated;
}

// 类方法
+ (instancetype)randomItem;

// 初始化方法（initialization method）：用于初始化类的对象的方法
// BNRItem 类的指定初始化方法
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;

// 声明存取方法，用于存取实例变量
- (void)setItemName:(NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)v;
- (int)valueInDollars;

- (NSDate *)dateCreated;

@end

NS_ASSUME_NONNULL_END
