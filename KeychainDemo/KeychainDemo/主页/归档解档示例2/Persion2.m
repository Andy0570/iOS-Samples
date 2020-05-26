//
//  Persion2.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/31.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "Persion2.h"
#import <YYKit.h>

@implementation Persion2

#pragma mark - Public

- (void)setNum:(int)num
      latitude:(float)latitude
    longtitude:(float)longtitude
    loginState:(BOOL)islogin
    identifier:(NSString *)identifier
         title:(NSString *)title
{
    self.num = num;
    self.latitude = latitude;
    self.longtitude = longtitude;
    self.isLogin = islogin;
    self.identifier = identifier;
    self.title = title;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}


#pragma mark - NSObject

- (NSString *)description {
    return [self modelDescription];
}

@end
