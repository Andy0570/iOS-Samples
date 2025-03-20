//
//  RWDummySignInService.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/20.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "RWDummySignInService.h"

@implementation RWDummySignInService

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                  complete:(RWSignInResponse)completeBlock
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
}

@end
