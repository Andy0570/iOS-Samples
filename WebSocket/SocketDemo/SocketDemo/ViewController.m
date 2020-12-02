//
//  ViewController.m
//  SocketDemo
//
//  Created by Qilin Hu on 2020/12/2.
//

#import "ViewController.h"
#import "CIMHeader.h"

@interface ViewController () <CIMPeerMessageObserver, CIMConnectionObserver, GCDAsyncSocketDelegate>

@property (strong, nonatomic) GCDAsyncSocket * clientSocket;

@property (nonatomic, strong) CIMService *service;
@property (nonatomic, strong) NSMutableString *logs;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)dealloc {
    [[CIMService instance] removeMessageObserver:self];
    [[CIMService instance] removeConnectionObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logs appendString:[NSString stringWithFormat:@"服务器IP: 192.168.0.111:34567\n"]];
    self.textView.text = self.logs;
    
//    [self setupGCDAsyncSocket];
    
    // 配置IM服务器
    [[CIMService instance] configHost:@"192.168.0.111" onPort:34567];
    // 连接服务器并绑定用户
    [[CIMService instance] connectionBindUserId:@"111111"];
    // 加连接状态监听回调
    [[CIMService instance] addConnectionObserver:self];
    // 添加消息监听回调
    [[CIMService instance] addMessageObserver:self];
}

- (void)setupGCDAsyncSocket {
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //连接服务器
    NSError *error;
    [_clientSocket connectToHost:@"47.102.118.65" onPort:34567 error:&error];
    if (error) {
        NSLog(@"socket 连接失败");
    } else {
        NSLog(@"socket 连接成功");
        
        SentBodyModel * body = [SentBodyModel new];

        body.key = @"client_bind";
        body.timestamp = (int64_t)[NSDate timeIntervalSinceReferenceDate] *1000;
        body.data_p[@"account"] = @"1111111222";
        body.data_p[@"deviceId"] = @"1221211";
        body.data_p[@"channel"] = @"ios";

        NSData *modeData = body.data;

        NSInteger lenght = modeData.length;

        Byte type = 3;

        Byte head[3] ;

        head[0] = type;
        head[1] = lenght & 0xff;
        head[2] = (lenght >> 8) & 0xff;

        NSMutableData * sendData = [[NSMutableData alloc] initWithBytes:head length:3];

        [sendData appendData:modeData];

        [_clientSocket writeData:[CIMSendMessageData initBindUserData:@"111111"] withTimeout:-1 tag:0];
    }
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


#pragma mark - GCDAsyncSocketDelegate

// 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
   NSLog(@"socket 连接成功");
   // 读取数据，必须添加，相当于主动添加一个读取请求，不然不会执行读取信息回调方法
   [_clientSocket readDataWithTimeout:-1 tag:0];
}

// 已经断开链接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
   NSLog(@"socket 断开连接%@",err.localizedDescription);

}

//读取到数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

   [_clientSocket readDataWithTimeout:-1 tag:0];

    NSData *head = [data subdataWithRange:NSMakeRange(0, 3)];//取得头部数据
    NSData * tagData = [head subdataWithRange:NSMakeRange(0, 1)];
    NSString* hexString = [tagData convertDataToHexStr];

    if([hexString isEqual:@"01"]){

        NSData * model = [@"CR" convertBytesStringToData];

        NSInteger lenght = model.length;

        Byte type = 0;

        Byte head[3] ;

        head[0] = type;
        head[1] = lenght & 0xff;
        head[2] = (lenght >> 8) & 0xff;

        NSMutableData * sendData = [[NSMutableData alloc] initWithBytes:head length:3];

        [sendData appendData:model];

        [_clientSocket writeData:sendData withTimeout:-1 tag:0];
    }

    if([hexString isEqual:@"02"]){

        NSData * lv = [data subdataWithRange:NSMakeRange(1, 1)];
        NSData * hv = [data subdataWithRange:NSMakeRange(2, 1)];

        NSString * lvString  = [[lv convertDataToHexStr] hexToDecimal];
        NSString * hvString  = [[hv convertDataToHexStr] hexToDecimal];
        
        NSLog(@"--hexHeight--%@",hvString);

        NSData * messageData = [data subdataWithRange:NSMakeRange(3, lvString.intValue)];

        NSError * error;

        MessageModel * messgae = [[MessageModel alloc] initWithData:messageData error:&error];

        NSLog(@"02:didReadData-----%@",messgae.content);

    }

    NSLog(@"didReadData----%@",hexString);
}

@end
