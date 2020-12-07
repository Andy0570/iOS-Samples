//
//  ViewController.m
//  SocketServer
//
//  Created by Qilin Hu on 2020/12/4.
//

#import "ViewController.h"
#import <GCDAsyncSocket.h>

@interface ViewController () <GCDAsyncSocketDelegate>

/// 服务端 Socket
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSImageView *imageView;

@property (nonatomic, strong) NSTimer *checkTimer;

@property (nonatomic, strong) NSDictionary *currentPackageHead;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupGCDAsyncSocket];
}

- (void)setupGCDAsyncSocket {
    // 创建 Socket 服务端
    _serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 监听 34567 端口
    NSError *error = nil;
    [_serverSocket acceptOnPort:34567 error:&error];
    if (error) {
        NSLog(@"监听出错：\n%@", error);
    } else {
        NSLog(@"正在监听...");
    }
}

#pragma mark - Actions

// 发送数据
- (IBAction)buttonAction:(id)sender {
    if (self.textField.stringValue.length == 0) { return; }
    
    // 服务端通过「客户端 socket 实例对象」向客户端发送数据
    NSData *sendData = [self.textField.stringValue dataUsingEncoding:NSUTF8StringEncoding];
    [_clientSocket writeData:sendData withTimeout:30 tag:0];
}

#pragma mark - Private

// 添加定时器
- (void)addTimer {
    // 长连接定时器，每隔 5s 发送一次心跳包
    self.checkTimer= [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkConnect) userInfo:nil repeats:YES];
    // 把定时器添加到当前运行循环,,并且调为通用模式
    [[NSRunLoop currentRunLoop] addTimer:self.checkTimer forMode:NSRunLoopCommonModes];
}

- (void)checkConnect {
    
}

#pragma mark - <GCDAsyncSocketDelegate>

// 接收到客户端的连接请求
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSLog(@"收到客户端连接....");
    
    // 保存客户端的 socket 连接
    _clientSocket = newSocket;
    
    // 添加定时器
    // [self addTimer];
    
    // 读取数据，必须添加，相当于主动添加一个读取请求，不然不会执行读取信息回调方法
    [newSocket readDataWithTimeout:-1 tag:0];
    
    // !!!: 读取数据，读取到 CRLFData 字符为止
//    [newSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

// 已经断开链接，协议方法
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"socket 断开连接");
}

// 读取到数据
// 当一个 socket 已经完成将请求的数据读入内存时调用。
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到数据：\n%@", receivedString);
    
    self.textView.string = [NSString stringWithFormat:@"收到数据：\n%@", receivedString];

    [sock readDataWithTimeout:-1 tag:0];
}

//- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//
//    // 先读取到当前数据包的头部
//    if (!_currentPackageHead) {
//        _currentPackageHead = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//        if (!_currentPackageHead) {
//            NSLog(@"Error, 当前数据包的头部信息为空");
//            // 断开这个 socket 连接或者丢弃这个包的数据进行下一个包的读取
//
//            return;
//        }
//
//        // 从头部信息中获取整个数据包的长度
//        NSUInteger packageLength = [_currentPackageHead[@"size"] integerValue];
//
//        // !!!: 读取到数据包的大小
//        [sock readDataToLength:packageLength withTimeout:-1 tag:0];
//
//        return;
//    }
//
//    // 正式的包处理
//    NSUInteger packageLength = [_currentPackageHead[@"size"] integerValue];
//    // 校验数据包长度
//    if (packageLength <= 0 || data.length != packageLength) {
//        NSLog(@"Error, 当前数据包大小不正确");
//        return;
//    }
//
//    // 根据数据类型执行不同的处理
//    NSString *type = _currentPackageHead[@"type"];
//
//    if ([type isEqualToString:@"img"]) {
//        self.imageView.image = [[NSImage alloc] initWithData:data];
//        NSLog(@"图片设置成功");
//    } else if ([type isEqualToString:@"txt"]) {
//        NSLog(@"收到消息：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//        self.textView.string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//
//    _currentPackageHead = nil;
//
//    // 继续读取数据，读取到 CRLFData 字符为止
//    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
//}

@end
