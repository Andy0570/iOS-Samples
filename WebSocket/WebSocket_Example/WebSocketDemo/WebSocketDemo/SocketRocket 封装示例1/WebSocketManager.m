//
//  WebSocketManager.m
//  WebSocketDemo
//
//  Created by Qilin Hu on 2020/12/1.
//

#import "WebSocketManager.h"
#import <SRWebSocket.h>

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

static WebSocketManager *_sharedInstance = nil;
static NSString * const kHost = @"192.168.0.198";
static const uint16_t kPort = 3000;

@interface WebSocketManager () <SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSTimer *heartBeat;
@property (nonatomic, assign) NSTimeInterval reconnectTime;
@end

@implementation WebSocketManager

#pragma mark - Initialize

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance setupWebSocket];
    });
    return _sharedInstance;
}

#pragma mark - Public

- (void)open {
    [self setupWebSocket];
}

- (void)close {
    if (self.webSocket) {
        [self.webSocket close];
        self.webSocket = nil;
    }
}

// 发送消息
- (void)sendMessage:(NSString *)message {
    [self.webSocket send:message];
}

// pingpong
- (void)ping {
    // Send Data (can be nil) in a ping message.
    [self.webSocket sendPing:nil];
}

#pragma mark - Private

// 初始化 WebSocket
- (void)setupWebSocket {
    if (self.webSocket) { return; }
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%d", kHost, kPort]]];
    self.webSocket.delegate = self;
    
    // 设置代理线程 queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [self.webSocket setDelegateOperationQueue:queue];
    
    // 连接
    [self.webSocket open];
}

// 初始化心跳
- (void)setupHeartBeat {
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        
        __weak __typeof(self)weakSelf = self;
        // 心跳设置为 3 分钟，NAT 超时一般为 5 分钟
        self.heartBeat = [NSTimer scheduledTimerWithTimeInterval:3*60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            // 和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
            [weakSelf sendMessage:@"HeartBeat Flag"];
        }];
        [[NSRunLoop currentRunLoop] addTimer:self.heartBeat forMode:NSRunLoopCommonModes];
    });
}

// 取消心跳
- (void)destoryHeartBeat {
    // 删除定时器
    dispatch_main_async_safe(^{
        if (self.heartBeat) {
            [self.heartBeat invalidate];
            self.heartBeat = nil;
        }
    });
}

// 重连机制
- (void)reconnect {
    [self close];
    
    // 超过一分钟就不再重连，之后重连 5 次，2^5 = 64
    if (self.reconnectTime > 64) { return; }
    
    // 延后执行，重新初始化 WebSocket
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reconnectTime * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        self.webSocket = nil;
        [self setupWebSocket];
    });
    
    // 重连时间以2的指数级增长
    if (self.reconnectTime == 0) {
        self.reconnectTime = 2;
    } else {
        self.reconnectTime *= 2;
    }
}

#pragma mark - SRWebSocketDelegate

// 接受消息的代理方法
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"服务器返回的信息：%@",message);
}

// 打开 websocket 成功的回调
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 连接成功，开始发送心跳
    [self setupHeartBeat];
}

// 发生错误的回调
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"%@",error.localizedDescription);
    
    // 重连
    [self reconnect];
}

// websocket 关闭的回调
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    // 被关闭连接，如果是被用户中断，则直接断开连接，否则自动重连
    if (code == WebSocketClosedTypeByUser) {
        [self close];
    } else {
        [self reconnect];
    }
    
    // 断开连接时销毁心跳
    [self destoryHeartBeat];
}

// sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
// 这里是连接 Websocket 失败的方法，这里面一般都会写重连的方法
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"收到服务器的 Pong 消息");
}

@end
