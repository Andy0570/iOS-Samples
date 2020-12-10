//
//  HQLKeyArchiverViewController.h
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLKeyArchiverViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/*
参考 <https://www.jianshu.com/p/6ad8447ce8ac>
 
 对于 NSString、NSArray、NSDictionary、NSSet、NSDate、NSNumber 和 NSData 之类的基本 Objective-C 类对象，都可以直接使用 NSKeyedArchiver 归档和 NSKeyedUnarchiver 读取归档文件。

 # 三种归档方法的区别：
 
 1. archiveRootObject:toFile: 不能决定如何处理归档的数据，直接被写入了文件。
 2. initForWritingWithMutableData: 归档的数据可以通过网络分发，除此之外还可以把多个对象归档到一个缓冲区。
 3. archivedDataWithRootObject: 这种方法归档的数据可以通过网络分发，非常灵活。
 
 */


/**
 !!!: NSSecureCoding
 
 !!!: 领悟到 NSCoding 是一个坑，Apple 花了 10 年时间
 参考：<https://github.com/ChenYilong/iOS12AdaptationTips/issues/1>
 
 自定义类，Objective-C 开发者，使用 NSSecureCoding ，放弃使用 NSCoding ，具体用法上文已给出示例代码。Swift 开发者，启用 Codable。
 NSKeyedArchiver、NSKeyedUnarchiver 使用新的 API，让系统在编解码前校验属性类名，注意新 API 最低要从 iOS11/iOS12 起。
 */
