//
//  HQLKeyArchiverViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/30.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 主要内存：iOS 原生方式实现归档解档
@interface HQLKeyArchiverViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/*
 # 参考
 - <https://github.com/pro648/tips/wiki/%E6%95%B0%E6%8D%AE%E5%AD%98%E5%82%A8%E4%B9%8B%E5%BD%92%E6%A1%A3%E8%A7%A3%E6%A1%A3-NSKeyedArchiver-NSKeyedUnarchiver>
 - <https://www.jianshu.com/p/6ad8447ce8ac>
 
 对于 NSString、NSArray、NSDictionary、NSSet、NSDate、NSNumber 和 NSData 之类的基本 Objective-C 类对象，都可以直接使用 NSKeyedArchiver 归档和 NSKeyedUnarchiver 读取归档文件。

 # 三种归档方法的区别：
 
 1. archiveRootObject: toFile: 不能决定如何处理归档的数据，直接被写入了文件。
 2. initForWritingWithMutableData: 归档的数据可以通过网络分发，除此之外还可以把多个对象归档到一个缓冲区。
 3. archivedDataWithRootObject: 这种方法归档的数据可以通过网络分发，非常灵活。
 
 */
