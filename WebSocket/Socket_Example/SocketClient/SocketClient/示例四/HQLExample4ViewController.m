//
//  HQLExample4ViewController.m
//  SocketClient
//
//  Created by Qilin Hu on 2020/12/5.
//

#import "HQLExample4ViewController.h"
#import "CIMHeader.h"

@interface HQLExample4ViewController () <CIMPeerMessageObserver, CIMConnectionObserver>

@property (nonatomic, strong) CIMService *service;
@property (nonatomic, strong) NSMutableString *logs;

@end

@implementation HQLExample4ViewController

- (void)dealloc {
    [[CIMService instance] removeMessageObserver:self];
    [[CIMService instance] removeConnectionObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logs appendString:[NSString stringWithFormat:@"服务器IP: 192.168.0.111:34567\n"]];
    self.textView.text = self.logs;
    
    [self setupCIMService];
}

- (void)setupCIMService {
    // 配置IM服务器
    [[CIMService instance] configHost:@"192.168.0.111" onPort:34567];
    // 连接服务器并绑定用户
    [[CIMService instance] connectionBindUserId:@"111111"];
    // 加连接状态监听回调
    [[CIMService instance] addConnectionObserver:self];
    // 添加消息监听回调
    [[CIMService instance] addMessageObserver:self];
}

#pragma mark - Custom Accessors

- (NSMutableString *)logs {
    if (!_logs) {
        _logs = [[NSMutableString alloc] init];
    }
    return _logs;
}

#pragma mark - <CIMConnectionObserver>

/// 用户绑定成功
/// @param bindSuccess bindSuccess description
-(void)cimDidBindUserSuccess:(BOOL)bindSuccess {
    
}

/// 连接成功
-(void)cimDidConnectSuccess {
    [self.logs appendString:@"服务器连接成功.\n"];
    self.textView.text = self.logs;
}

/// 断开连接
-(void)cimDidConnectClose {
    [self.logs appendString:@"服务器断开连接.\n"];
    self.textView.text = self.logs;
}

/// 连接失败
/// @param error res description
-(void)cimDidConnectError:(NSError *_Nullable)error {
    NSString *errorInfo = [NSString stringWithFormat:@"服务器连接失败:\n%@\n", error.description];
    [self.logs appendString:errorInfo];
    self.textView.text = self.logs;
}

#pragma mark - <CIMPeerMessageObserver>

/// 接受到消息
/// @param msg msg description
-(void)cimHandleMessage:(CIMMessageModel * _Nonnull)msg {
    NSLog(@"ViewController:%@\nu用户：%@(%lld)\n---------",msg.content,msg.sender,msg.timestamp);
    NSString *message = [NSString stringWithFormat:@"接收到消息：%@\nu用户：%@(%lld)\n---------",msg.content,msg.sender,msg.timestamp];
    [self.logs appendString:message];
    self.textView.text = self.logs;
}

/// 消息解析失败
/// @param data data description
-(void)cimHandleMessageError:(NSData * _Nonnull)data {
    [self.logs appendString:@"消息解析失败"];
    self.textView.text = self.logs;
}


@end
