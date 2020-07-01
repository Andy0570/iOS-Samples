//
//  Person.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/30.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 iOS 数据持久化——对象归档
 参考：<https://my.oschina.net/fuzheng/blog/491915>
 */
@interface Person : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger age;

- (void)setName:(NSString *)name age:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END

/**
 Cocoa Touch 框架在归档、属性列表序列化和 Core Data 中采用了备忘录模式。
 
 当我们需要将模型对象编码到文档中，需要时再对其解码读取时，在运行时使用 NSCoder 对象进行编码与解码操作。
 但NSCoder 本身是一个抽象类。Apple 建议通过 NSCoder 的具体子类 NSKeyedArchiver 和 NSKeyedUnarchiver，也就是使用基于键的归档技术。被编码与解码的对象必须遵守 <NSCoding> 协议并实现以下方法：

 - (void)encodeWithCoder:(NSCoder *)coder;
 - (nullable instancetype)initWithCoder:(NSCoder *)coder;
 
 # 归档
 
 归档：是对对象及其属性还有同其他对象间的关系进行编码，形成一个文档，该文档既可以保存于文件系统，也可以在进程或网络间传送。
 
 归档过程把对象图保存为一种与架构无关的字节流，保持对象的标识以及对象间的关系。
 
 1. 首先，被归档的对象必须遵守 <NSCoding> 协议并实现以下方法：
 
 - (void)encodeWithCoder:(NSCoder *)coder;
 - (nullable instancetype)initWithCoder:(NSCoder *)coder;
 
 2. 其次，通过 NSCoder 的具体子类 NSKeyedArchiver 和 NSKeyedUnarchiver 实现归档和解档操作：
 
 归档：
 + (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path;
 
 解档：
 + (id)unarchiveObjectWithFile:(NSString *)path;
 
 */
