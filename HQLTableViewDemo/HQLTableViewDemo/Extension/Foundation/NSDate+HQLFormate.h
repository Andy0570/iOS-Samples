//
//  NSDate+HQLFormate.h
//  SeaTao
//
//  Created by Qilin Hu on 2021/10/9.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (HQLFormate)

/// 返回时间的字符串格式
- (NSString *)formattedDate;

@end

NS_ASSUME_NONNULL_END
