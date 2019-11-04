//
//  HQLDataModel.m
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/21.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLDataModel.h"

@implementation HQLDataModel

- (instancetype)initWithState:(BOOL *)isOpen
                    groupName:(NSString *)groupName
                   groupCount:(NSInteger )groupCount
                   modelArray:(NSArray *)modelArray{
    self = [super init];
    if (self) {
        _isOpen = isOpen;
        _groupName = groupName;
        _groupCount = groupCount;
        _modelArray = modelArray;
    }
    return self;
}

@end
