//
//  Item.h
//  2.1 RandomItems
//
//  Created by ToninTech on 16/8/11.
//  Copyright © 2016年 ToninTech. All rights reserved.
//
/**
 *  该对象表示某人在真实世界拥有的一件物品
 *
 */
#import <Foundation/Foundation.h>

// 头文件声明顺序：实例变量、类方法、初始化方法、其他方法
@interface Item : NSObject

// 名称
@property (nonatomic, copy) NSString *itemName;
// 序列号
@property (nonatomic, copy) NSString *serialNumber;
// 价值
@property (nonatomic) int valueInDollars;
// 创建日期
@property (nonatomic, readonly, strong) NSDate *dateCreated;
// 照片的key
@property (nonatomic, copy) NSString *itemKey;
// 照片缩略图
@property (nonatomic, strong) UIImage *thumbnail;

//类方法
+ (instancetype)randomItem;

// Item类的指定初始化方法
// instancetype,该关键字表示的返回值类型和调用方法的类型相同，
// init方法的返回值类型都声明为instancetype
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

// 其他初始化方法
- (instancetype)initwithName:(NSString *)name serialNumber:(NSString *)sNumber;
- (instancetype)initWithItemName:(NSString *)name;

// 根据全尺寸图片设置照片缩略图
- (void)setThumbnailFromImage:(UIImage *)image;

@end
