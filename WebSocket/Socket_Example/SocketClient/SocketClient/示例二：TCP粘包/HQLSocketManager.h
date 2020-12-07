//
//  HQLSocketManager.h
//  SocketClient
//
//  Created by Qilin Hu on 2020/12/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLSocketManager : NSObject

+ (instancetype)share;

- (BOOL)connect;
- (void)disConnect;

- (void)sendMsg;

@end

NS_ASSUME_NONNULL_END
