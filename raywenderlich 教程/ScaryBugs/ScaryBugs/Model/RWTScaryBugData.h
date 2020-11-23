//
//  RWTScaryBugData.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 模型类，包含昆虫的名称和评级
@interface RWTScaryBugData : NSObject <NSSecureCoding> // #1 遵守 NSSecureCoding 协议

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) float rating;

- (instancetype)initWithTitle:(NSString *)title rating:(float)rating;

@end

NS_ASSUME_NONNULL_END

/**
 关于 NSCoding 的更多细节：
 [Friday Q&A 2010-08-12: Implementing NSCoding @Mike Ash](https://www.mikeash.com/pyblog/friday-qa-2010-08-12-implementing-nscoding.html)
 [领悟到 NSCoding 是一个坑，Apple 花了 10 年时间](https://juejin.cn/entry/6844903695579119629)
 
 NSCoding 是一种非安全的编解码方式，使用 NSKeyedArchiver 归档自定义类对象做持久化存储。由于未做数据校验，可通过篡改本地存储的信息进行攻击。从 IOS 6.0 之后引入了 NSSecureCoding 来保证数据安全。

 NSSecureCoding 协议继承自 NSCoding，有着比 NSCoding 更加安全的编码和解码。
 
 - (instancetype)initRequiringSecureCoding:(BOOL)requiresSecureCoding API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));
 + (nullable NSData *)archivedDataWithRootObject:(id)object requiringSecureCoding:(BOOL)requiresSecureCoding error:(NSError **)error API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0));
 
 
 1. 自定义类时：Objective-C 开发者，使用 NSSecureCoding ，放弃使用 NSCoding。Swift 开发者，启用 Codable。
 2. NSKeyedArchiver、NSKeyedUnarchiver 使用新的 API，让系统在编解码前校验属性类名，注意新 API 最低要从 iOS11/iOS12 起。
 
 
 */
