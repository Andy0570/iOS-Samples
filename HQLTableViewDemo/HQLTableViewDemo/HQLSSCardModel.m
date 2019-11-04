//
//  HQLSSCardModel.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/12/28.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import "HQLSSCardModel.h"
#import <YYKit.h>

@interface HQLSSCardModel ()

@property (nonatomic, readwrite, copy) NSString *idNumber;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, assign) BOOL isMasterCard;

@end

@implementation HQLSSCardModel

#pragma mark - NSObject

- (NSString *)description {
    return [self modelDescription];
}

@end
