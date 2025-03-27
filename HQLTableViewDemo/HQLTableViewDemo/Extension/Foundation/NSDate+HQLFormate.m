//
//  NSDate+HQLFormate.m
//  SeaTao
//
//  Created by Qilin Hu on 2021/10/9.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "NSDate+HQLFormate.h"
#import <NSDate+DateTools.h>
#import <JKCategories.h>

@implementation NSDate (HQLFormate)

- (NSString *)formattedDate {
    if ([self isToday]) { // 今天
        return [self formattedDateWithFormat:@"今天 aHH:mm"];
    } else if ([self isYesterday]) { // 昨天
        return [self formattedDateWithFormat:@"昨天 HH:mm"];
    } else if ([self jk_isThisWeek]) { // 本周
        return [NSString stringWithFormat:@"%@ %@", self.jk_dayFromWeekday, [self jk_formatWithLocalTimeWithoutDate]];
    } else if ([self jk_isThisYear]) { // 今年
        return [self formattedDateWithFormat:@"M月d日 aHH:mm"];
    } else {
        return [self jk_formatWithLocalTimeZone];
    }
}

@end
