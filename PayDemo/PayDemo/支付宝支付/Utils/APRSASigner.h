//
//  APRSASigner.h
//  AliSDKDemo
//
//  Created by antfin on 17-10-24.
//  Copyright (c) 2017年 AntFin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APRSASigner : NSObject

- (id)initWithPrivateKey:(NSString *)privateKey;

- (NSString *)signString:(NSString *)string withRSA2:(BOOL)rsa2;

@end
