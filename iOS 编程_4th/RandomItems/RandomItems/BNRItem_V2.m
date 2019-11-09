//
//  BNRItem_V2.m
//  RandomItems
//
//  Created by Qilin Hu on 2019/11/7.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import "BNRItem_V2.h"

@implementation BNRItem_V2

#pragma mark - Initialize

+ (instancetype)randomItem {
    // 创建不可变数组对象，包含三个形容词
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    // 创建不可变数组对象，包含三个名词
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    // 根据数组对象所包含的对象个数，得到随机索引
    // 注意：运算符 % 是模运算符，运算后得到的是余数
    // 因此 adjectiveIndex 是一个 0 ～ 2 （包括 2）的随机数
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    // 注意：类型为 NSInteger 的变量不是对象
    // NSInteger 是一种针对 unsigned long （无符号长整数）的类型定义
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    
    // 调用指定初始化方法，并传入上面步骤创建好的随机数据作为参数。
    BNRItem_V2 *newItem = [[self alloc] initWithItemName:randomName
                                          valueInDollars:randomValue
                                            serialNumber:randomSerialNumber];
    return newItem;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber
{
    // 调用父类的指定初始化方法
    self = [super init];
    // 父类的指定初始化方法是否成功创建了父类对象
    if (self) {
        // 为实例变量设定初始值
        // 在初始化方法中，应该直接访问实例变量。
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        // 设置 _dateCreated 的值为系统当前时间
        _dateCreated = [[NSDate alloc] init];
    }
    // 返回初始化后的对象的新地址
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

/*
 覆盖子类的 init 方法，将其与指定初始化方法“串联”起来。
 
 串联（ chain）使用初始化方法的机制可以减少错误，也更容易维护代码。
 在创建类时，需要先确定指定初始化方法，然后只在指定初始化方法中编写初始化的核心代码，其他初始化方法只需要调用指定初始化方法（直接或间接）并传入默认值即可。
 */
- (instancetype)init {
    return [self initWithItemName:@"item"];
}

#pragma mark - Override

// 子类覆盖父类的方法
// 使用存取方法访问实例变量是良好的编程习惯，即使是访问对象自身的实例变量，也应该使用存取方法。
- (NSString *)description {
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@):Worth $%d, recorded on %@",
                                   self.itemName,
                                   self.serialNumber,
                                   self.valueInDollars,
                                   self.dateCreated];
    return  descriptionString;
}

@end
