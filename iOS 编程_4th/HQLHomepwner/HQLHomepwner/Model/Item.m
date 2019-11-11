//
//  Item.m
//  2.1 RandomItems
//
//  Created by ToninTech on 16/8/11.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

// #import 可以确保不会重复导入同一个文件
#import "Item.h"

@implementation Item

// 类方法
+ (instancetype)randomItem{
    
    //创建不可变数组对象，包含三个形容词
    NSArray *randomAdjectiveList = @[@"Fluffy",@"Rusty",@"Shiny"];
    
    //创建三个不可变数组对象，包含三个名词
    NSArray *randomNounList = @[@"Bear",@"Spark",@"Mac"];
    
    //根据数组对象所含对象的个数，得到随机索引
    //注意：运算符%是模运算符，运算后得到的是余数
    //因此 adjectiveIndex 是一个0到2（包括2）的随机数
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@%@",
                            randomAdjectiveList [adjectiveIndex],
                            randomNounList [nounIndex]];
    
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%C%C%C%C%C",
                                    (unichar)('0'+arc4random() % 10),
                                    (unichar)('A'+arc4random() % 26),
                                    (unichar)('0'+arc4random() % 10),
                                    (unichar)('A'+arc4random() % 26),
                                    (unichar)('0'+arc4random() % 10)];
    
    Item *newItem = [[self alloc] initWithItemName:randomName
                                    valueInDollars:randomValue
                                      serialNumber:randomSerialNumber];
    
    return newItem;
}


// 串联（chain）使用初始化方法
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber {
    
    self = [super init];
    //if(self):父类的指定初始化方法是否成功创建了父类对象？
    if(self){
        _itemName       = name;
        _serialNumber   = sNumber;
        _valueInDollars = value;
        // 设置_dateCreated的值为系统当前时间
        _dateCreated    = [[NSDate alloc] init];
        // 创建一个 NSUUID 对象，然后获取其 NSString 类型的值
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    //返回初始化后的对象的新地址
    return self;
}

- (instancetype)initwithName:(NSString *)name
                serialNumber:(NSString *)sNumber {
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:sNumber];
    
}

- (instancetype)initWithItemName:(NSString *)name {
    // 调用指定初始化方法
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:@""];
}

- (instancetype)init {
    return [self initWithItemName:@"Item"];
}

// 生成缩略图
- (void)setThumbnailFromImage:(UIImage *)image {
    CGSize origImageSize = image.size;
    // 缩略图的大小
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    // 确定缩放倍数并保持宽高比不变
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height/origImageSize.height);
    
    // 根据当前设备的屏幕 scailing factor 创建透明的位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    // 创建表示圆角矩形的 UIBezierPath
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    // 根据 UIBezierPath 对象裁剪图形上下文
    [path addClip];
    // 让图片在缩略图绘制范围内居中
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    // 在上下文中绘制图片
    [image drawInRect:projectRect];
    // 通过图形上下文得到 UIImage 对象，并将其赋给 thumbnail 属性
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // 清理图形上下文
    UIGraphicsEndImageContext();
}

// 覆写 description 方法
// %@,对应的实参类型是指向任何一种对象的指针，首先返回的是该实参的 description 消息
- (NSString *)description {
    NSString *descriptionString =
        [[NSString alloc] initWithFormat:@"%@(%@): ,Worth $%d ,recorded on %@",
                                        self.itemName,
                                        self.serialNumber,
                                        self.valueInDollars,
                                        self.dateCreated ];
    return descriptionString;
}


#pragma mark - NSCoding

// 固化
- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject :self.itemName       forKey      :@"itemName"];
    [aCoder encodeObject :self.serialNumber   forKey  :@"serialNumber"];
    [aCoder encodeObject :self.dateCreated    forKey   :@"dateCreated"];
    [aCoder encodeObject :self.itemKey        forKey       :@"itemKey"];
    [aCoder encodeObject :self.thumbnail      forKey     :@"thumbnail"];
    [aCoder encodeInt    :self.valueInDollars forKey:@"valueInDollars"];
}

// 解固
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _itemName       = [aDecoder decodeObjectForKey     :@"itemName"];
        _serialNumber   = [aDecoder decodeObjectForKey :@"serialNumber"];
        _dateCreated    = [aDecoder decodeObjectForKey  :@"dateCreated"];
        _itemKey        = [aDecoder decodeObjectForKey      :@"itemKey"];
        _thumbnail      = [aDecoder decodeObjectForKey    :@"thumbnail"];
        _valueInDollars = [aDecoder decodeIntForKey  :@"valueInDollars"];
    }
    return self;
}

@end
