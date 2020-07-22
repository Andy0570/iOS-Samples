//
//  HQLContactGroup.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/29.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLContactGroup.h"

@implementation HQLContactGroup

// 静态初始换方法
+ (HQLContactGroup *)initWithName:(NSString *)name
                           detail:(NSString *)detail
                         contacts:(NSMutableArray *)contacts {
    HQLContactGroup *group = [[HQLContactGroup alloc] initWithName:name
                                                            detail:detail
                                                          contacts:contacts];
    return group;
}

// 构造方法
- (HQLContactGroup *)initWithName:(NSString *)name
                           detail:(NSString *)detail
                         contacts:(NSMutableArray *)contacts {
    self = [super init];
    if (self) {
        _name = name;
        _detail = detail;
        _contacts = contacts;
    }
    return self;
}

@end
