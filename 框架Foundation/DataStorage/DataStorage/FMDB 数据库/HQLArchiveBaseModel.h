//
//  HQLArchiveBaseModel.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 一个实现了归档协议的基类
 
 参考：<https://www.jianshu.com/p/45267dfca32f>
 */
@interface HQLArchiveBaseModel : NSObject <NSCoding, NSCopying>

@end

NS_ASSUME_NONNULL_END
