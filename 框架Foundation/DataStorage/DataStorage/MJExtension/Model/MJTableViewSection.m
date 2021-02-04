//
//  MJTableViewSection.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/16.
//

#import "MJTableViewSection.h"
#import <MJExtension.h>

@implementation MJTableViewCell

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"imageName":@"image"
    };
}

/**
 *  旧值换新值，用于过滤字典中的值
 *
 *  @param oldValue 旧值
 *
 *  @return 新值
 */
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    
    // MARK: MJExtension 缺点：不支持自动类型转换
    // 自定义类型转换，NSString -> NSDate
    if ([property.name isEqualToString:@"date"]) {
        if (oldValue == nil) {
            return nil;
        } else if (property.type.typeClass == [NSDate class]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
            return [dateFormatter dateFromString:oldValue];
        }
    }
    
    return oldValue;
}

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    NSLog(@"当字典转模型完毕时调用,keyValues:\n%@",keyValues);
}

- (void)mj_objectDidConvertToKeyValues:(NSMutableDictionary *)keyValues {
    NSLog(@"当模型转字典完毕时调用,keyValues:\n%@",keyValues);
}

@end

@implementation MJTableViewSection

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"cells": MJTableViewCell.class
    };
}

@end
