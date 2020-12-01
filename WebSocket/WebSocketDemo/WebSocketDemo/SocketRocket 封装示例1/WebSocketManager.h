//
//  WebSocketManager.h
//  WebSocketDemo
//
//  Created by Qilin Hu on 2020/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// WebSocket 断开连接的类型
typedef NS_ENUM(NSUInteger, WebSocketClosedType) {
    WebSocketClosedTypeByUser,
    WebSocketClosedTypeByServer
};

@interface WebSocketManager : NSObject

+ (instancetype)share;

- (void)open;
- (void)close;

- (void)sendMessage:(NSString *)message;
- (void)ping;

@end

NS_ASSUME_NONNULL_END
