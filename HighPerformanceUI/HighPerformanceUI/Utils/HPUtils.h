//
//  HPUtils.h
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/5.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 工具类，计算时间消耗
 
 //https://gist.github.com/bignerdranch/2006587
 */
@interface HPUtils : NSObject

+(uint64_t)timeBlock:(void (^)(void))block;
+(uint64_t)nanosUsingStart:(uint64_t)start end:(uint64_t)end;

@end
