//
//  HQLBasicViewController.m
//  SocketClient
//
//  Created by Qilin Hu on 2020/12/4.
//

#import "HQLBasicViewController.h"
#import <GCDAsyncSocket.h>

@interface HQLBasicViewController () <GCDAsyncSocketDelegate>

/// 客户端 Socket
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSTimer *connectTimer;

@end

@implementation HQLBasicViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGCDAsyncSocket];
}

- (void)setupGCDAsyncSocket {
    // 创建 Socket 客户端
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 连接到服务器 192.168.0.198:34567
    NSError *error;
    BOOL isConnected = [_clientSocket connectToHost:@"192.168.0.198" onPort:34567 error:&error];
    if (!isConnected) {
        NSLog(@"socket 连接失败:%@\n", error);
        return;
    }
    
    NSLog(@"socket 连接成功");
}

#pragma mark - Actions

// 发送消息
- (IBAction)sendButtonAction:(id)sender {
    if (self.textField.text.length == 0) { return; }
    
    NSData *sendData = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    [_clientSocket writeData:sendData withTimeout:30 tag:0];
    
    // 模拟连续发消息，测试 TCP 粘包问题
    // 测试连续发送 5 条数据
    NSData *data1 = [@"你好" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data2 = [@"千山鸟飞绝，万径人踪灭，孤舟蓑笠翁，独钓寒江雪" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data3 = [@"我" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data4 = [@"路漫漫其修远兮，吾将上下而求索" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data5 = [@"先生" dataUsingEncoding:NSUTF8StringEncoding];
    
    [_clientSocket writeData:data1 withTimeout:30 tag:0];
    [_clientSocket writeData:data2 withTimeout:30 tag:0];
    [_clientSocket writeData:data3 withTimeout:30 tag:0];
    [_clientSocket writeData:data4 withTimeout:30 tag:0];
    [_clientSocket writeData:data5 withTimeout:30 tag:0];
    
    // 测试发送一张图片
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yoona" ofType:@"jpg"];
//    NSData *imgData = [NSData dataWithContentsOfFile:filePath];
//    [_clientSocket writeData:imgData withTimeout:30 tag:0];
}

#pragma mark - Private

// 添加定时器
- (void)addTimer {
    // 长连接定时器，每隔 5s 发送一次心跳包
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    // 把定时器添加到当前运行循环,,并且调为通用模式
    [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
}

// 发送心跳包
- (void)longConnectToSocket {
    // 发送固定格式的数据
    float version = [[UIDevice currentDevice] systemVersion].floatValue;
    NSString *longConnect = [NSString stringWithFormat:@"123%f",version];
    
    NSData *data = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

#pragma mark - GCDAsyncSocketDelegate

/**
 * 当一个 socket 连接成功并准备好读写时调用。
 * host 参数是一个 IP 地址，而不是 DNS 名称。
**/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"IP: %@:%d，socket 连接成功并准备读写",host, port);
    
    // 添加定时器，定时发送心跳包
    [self addTimer];
    
    // 读取数据，必须添加，相当于主动添加一个读取请求，不然不会执行读取信息回调方法
    [_clientSocket readDataWithTimeout:-1 tag:0];
}

// 当 socket 断开连接时调用，可能有错误，可能没有错误。
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"socket 断开连接");
    
    // 断开连接后，清空客户端 socket 及其代理
    self.clientSocket.delegate = nil;
    self.clientSocket = nil;
}

// 当一个 socket 已经完成将请求的数据读入内存时调用。
// 如果发送错误就不会被调用。
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.textView.text = [NSString stringWithFormat:@"收到数据：\n%@", receivedString];
    
    // 注意：要想长连接，必须还要在 DidReceiveData 的 delegate 中再写一次 [_clientSocket receiveOnce:&error]
    // 读取数据，读取完信息后，重新向队列中添加一个读取请求，不然当收到信息后不会执行读取回调方法。
    [_clientSocket readDataWithTimeout:-1 tag:0];
}

@end
