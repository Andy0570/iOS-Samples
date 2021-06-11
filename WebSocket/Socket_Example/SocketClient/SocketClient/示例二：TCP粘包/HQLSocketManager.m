//
//  HQLSocketManager.m
//  SocketClient
//
//  Created by Qilin Hu on 2020/12/4.
//

#import "HQLSocketManager.h"
#import <GCDAsyncSocket.h>

static HQLSocketManager *_sharedInstance = nil;

// Socket 服务器IP地址和端口号
static NSString * const kHost = @"192.168.0.198";
static const uint16_t kPort = 34567;

@interface HQLSocketManager () <GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@end

@implementation HQLSocketManager

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance setupGCDAsyncSocket];
    });
    return _sharedInstance;
}

- (void)setupGCDAsyncSocket {
    // 创建 Socket 客户端
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - Public

// 建立连接
- (BOOL)connect {
    // 连接到服务器 192.168.0.198:34567
    NSError *error;
    BOOL isConnect = [_clientSocket connectToHost:kHost onPort:kPort error:&error];
    if (isConnect) {
        NSLog(@"socket 连接成功");
    } else {
        NSLog(@"socket 连接失败");
    }
    return isConnect;
}

// 断开连接
- (void)disConnect {
    [_clientSocket disconnect];
}

// 测试发送消息
- (void)sendMsg {
    // 测试连续发送 5 条数据
    NSData *data1 = [@"你好" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [@"先生" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data3 = [@"我" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data4 = [@"床前明月光" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data5 = [@"独钓寒江雪" dataUsingEncoding:NSUTF8StringEncoding];
    
    [self sendData:data1 type:@"txt"];
    [self sendData:data2 type:@"txt"];
    [self sendData:data3 type:@"txt"];
    [self sendData:data4 type:@"txt"];
    [self sendData:data5 type:@"txt"];
    
    // 测试发送一张图片
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yoona" ofType:@"jpg"];
    NSData *imgData = [NSData dataWithContentsOfFile:filePath];
    [self sendData:imgData type:@"img"];
}

- (void)sendData:(NSData *)data type:(NSString *)type {
    NSUInteger size = data.length;
    
    // NSDictionary -> JSON String
    NSMutableDictionary *headDictionary = [NSMutableDictionary dictionary];
    [headDictionary setObject:type forKey:@"type"];
    [headDictionary setObject:[NSString stringWithFormat:@"%ld", size] forKey:@"size"];
    NSString *jsonString = [self dictionaryToJson:headDictionary.copy];
    
    // JSON String -> Data
    NSData *lengthData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData dataWithData:lengthData];
    // 分界
    [mutableData appendData:[GCDAsyncSocket CRLFData]];
    [mutableData appendData:data];
    
    // 第二个参数，请求超时时间
    [_clientSocket writeData:mutableData withTimeout:-1 tag:0];
}

// 将 Dictionary 转换为 JSON String
- (NSString *)dictionaryToJson:(NSDictionary *)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - <GCDAsyncSocketDelegate>

/**
 * 当一个 socket 连接成功并准备好读写时调用。
 * host 参数是一个 IP 地址，而不是 DNS 名称。
**/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"IP: %@:%d，socket 连接成功并准备读写",host, port);
    
    //TODO: 添加定时器，定时发送心跳包
    
    // 读取数据，必须添加，相当于主动添加一个读取请求，不然不会执行读取信息回调方法
    [_clientSocket readDataWithTimeout:-1 tag:0];
}

// 当 socket 断开连接时调用，可能有错误，可能没有错误。
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"socket 断开连接");
    
    //TODO: 判断断线原因，并执行断线重连...
    
    // 断开连接后，清空客户端 socket 及其代理
    self.clientSocket.delegate = nil;
    self.clientSocket = nil;
}

// 当一个 socket 已经完成将请求的数据读入内存时调用。
// 如果发送错误就不会被调用。
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到数据：\n%@", receivedString);
    
    // 注意：要想长连接，必须还要在 DidReceiveData 的 delegate 中再写一次 [_clientSocket receiveOnce:&error]
    // 读取数据，读取完信息后，重新向队列中添加一个读取请求，不然当收到信息后不会执行读取回调方法。
    [_clientSocket readDataWithTimeout:-1 tag:0];
}

@end
