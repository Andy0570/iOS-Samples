//
//  HQLUserDefaultsViewController.h
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 主要内容：
 
 使用偏好设置（NSUserDefaults）、属性列表（plist）、归档解档（NSKeyedUnarchiver）保存数据、恢复数据
 参考：<https://www.jianshu.com/p/ebc7badfd8bb>
 
 ## 使用 User Defaults 保存设置
 
 * NSUserDefaults 从用户的默认数据库读取程序设置，NSUserDefaults 的缓存避免了每次获取数据都要读取数据库。
 * NSUserDefaults 可以保存 float、double、integer、Boolean、NSURL、NSData、NSString、NSNumber、NSDate、NSArray 和 NSDictionary 类型的数据。
 * NSUserDefaults 返回的值是不可变的，尽管保存时值是可变的。例如：设定一个可变字符串为 MyStringDefault 的值，之后用 stringForKey: 获取到的字符串将不可变。
 * NSUserDefaults 是线程安全的。
 * !!!: 任何保存在偏好设置的数据，如没有明确删除会永远保存在这里。所以，不要使用 NSUserDefaults 保存偏好设置外其他内容。

 
 ## 使用 Plist 保存数据
 
 * Plist 是一个标准的保存文本和设置的方式，Plist 的数据可以是 XML 格式或二进制格式，也可以在这两种格式间转换，
 * Plist 支持数据类型有 NSData、NSDate、NSNumber、NSString、NSArray 和 NSDictionary，
 * writeToFile:atomically: 方法会自动检测数据类型，如果不是这些类型，会返回 false；反之，返回 true。

 */
@interface HQLUserDefaultsViewController : UIViewController

@end

NS_ASSUME_NONNULL_END


/**
 !!!: NSUserDefaults 偏好设置使用示例
 
 // MARK: 保存 Access Token
 - (void)saveAccessToken:(NSString *)accessToken {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:accessToken forKey:@"Access_Token"];
     [defaults synchronize];
 }

 // MARK: 读取 Access Token
 - (NSString *)readAccessToken {
     return [[NSUserDefaults standardUserDefaults] stringForKey:@"Access_Token"];
 }

 // MARK: 删除 Access Token
 - (void)removeAccessToken {
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Access_Token"];
 }
 */
