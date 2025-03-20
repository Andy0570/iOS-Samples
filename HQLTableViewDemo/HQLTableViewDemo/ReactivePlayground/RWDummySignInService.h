//
//  RWDummySignInService.h
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/20.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RWSignInResponse)(BOOL);

@interface RWDummySignInService : NSObject

- (void)signInWithUsername:(NSString *)username
                  password:(NSString *)password
                  complete:(RWSignInResponse)completeBlock;

@end

NS_ASSUME_NONNULL_END
