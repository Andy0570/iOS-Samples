//
//  ViewController.m
//  WebSocketDemo
//
//  Created by Qilin Hu on 2020/12/1.
//

#import "ViewController.h"
#import <SRWebSocket.h>

@interface ViewController () <SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@end

@implementation ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Custom Accessors

- (SRWebSocket *)webSocket {
    if (!_webSocket) {
        // URL 格式: @"ws://ip地址:端口号"
        // 当服务器使用 socket.io 框架时，URL 格式：
        // @"ws://ip地址:端口号/socket.io/?EIO=4&transport=websocket"
        NSURL *url = [NSURL URLWithString:@"ws://192.168.0.198:3000"];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        _webSocket = [[SRWebSocket alloc] initWithURLRequest:urlRequest];
        _webSocket.delegate = self;
    }
    return _webSocket;
}

#pragma mark - Actions

- (IBAction)connectAction:(id)sender {
    [self.webSocket open];
}

#pragma mark - SRWebSocketDelegate

// 接受消息的代理方法，这里接受服务器返回的数据，方法里面应该写处理数据，存储数据的方法
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@",message);
}

// 打开 websocket 成功的回调
// 就像微信刚刚连接中，会显示连接中，当连接上了，就不显示连接中了，取消显示连接的方法就应该写在这里面
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 发生错误的回调
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"%@",error.localizedDescription);
}

// websocket 关闭的回调
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

// 来自服务器的 Pong 消息
// 这里是连接 Websocket 失败的方法，这里面一般都会写重连的方法
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
