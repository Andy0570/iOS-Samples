//
//  HQLWechatPayRequestModel.m
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/12/24.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import "HQLWechatPayRequestModel.h"
#import <YYKit/NSObject+YYModel.h>

@interface HQLWechatPayRequestModel ()

@property (nonatomic, copy, readwrite) NSString *appid;
@property (nonatomic, copy, readwrite) NSString *partnerid;
@property (nonatomic, copy, readwrite) NSString *prepayid;
@property (nonatomic, copy, readwrite) NSString *package;
@property (nonatomic, copy, readwrite) NSString *noncestr;
@property (nonatomic, assign, readwrite) UInt32 timestamp;
@property (nonatomic, copy, readwrite) NSString *sign;

@end

@implementation HQLWechatPayRequestModel

#pragma mark - NSObject

- (NSString *)description {
    return [self modelDescription];
}

@end
