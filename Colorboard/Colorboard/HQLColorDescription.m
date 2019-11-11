//
//  HQLColorDescription.m
//  Colorboard
//
//  Created by ToninTech on 16/10/18.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLColorDescription.h"

@implementation HQLColorDescription

- (instancetype) init {
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        _name = @"蓝色";
    }
    return self;
    
}

@end
