//
//  HQLCity.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCity.h"

@interface HQLCity ()

@property (nonatomic, readwrite, copy) NSString *area;
@property (nonatomic, readwrite, copy) NSString *code;
@property (nonatomic, readwrite, copy) NSString *first_char;
@property (nonatomic, readwrite, copy) NSString *ID;
@property (nonatomic, readwrite, copy) NSString *listorder;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *parentid;
@property (nonatomic, readwrite, copy) NSString *pinyin;
@property (nonatomic, readwrite, copy) NSString *region;

@end

@implementation HQLCity

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"ID" : @"id"
    };
}

- (NSString *)description {
    return [self modelDescription];
}

@end
