//
//  HQLExample3ViewController.m
//  SocketClient
//
//  Created by Qilin Hu on 2020/12/5.
//

#import "HQLExample3ViewController.h"
#import <GCDAsyncSocket.h>
#import <JVFloatLabeledTextField.h>
#import <JKCategories.h>
#import <Masonry.h>
#import "CIMHeader.h"

@interface HQLExample3ViewController () <GCDAsyncSocketDelegate>

@property (strong, nonatomic) GCDAsyncSocket * clientSocket;

@property (nonatomic, strong) JVFloatLabeledTextField *hostTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *portTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *messageTextField;

@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) UIButton *disConnectButton;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) NSMutableString *logs;

@end

@implementation HQLExample3ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _themeColor = [UIColor jk_colorWithHexString:@"#108EE9"];
    self.hostTextField.text = @"192.168.0.111";
    self.portTextField.text = @"34567";
    
    [self setupGCDAsyncSocket];
    [self setupSubViews];
}

- (void)setupGCDAsyncSocket {
    // 创建 Socket 客户端
    _clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)setupSubViews {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.hostTextField];
    [self.view addSubview:self.portTextField];
    [self.view addSubview:self.messageTextField];
    [self.view addSubview:self.connectButton];
    [self.view addSubview:self.disConnectButton];
    [self.view addSubview:self.sendButton];
    [self.view addSubview:self.contentLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.hostTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(40);
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.size.mas_equalTo(CGSizeMake(180, 55));
    }];
    [self.portTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(40);
        make.left.mas_equalTo(self.hostTextField.mas_right).offset(20);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
        make.height.mas_equalTo(55);
    }];
    
    [self.connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hostTextField.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.size.mas_equalTo(CGSizeMake(55, 30));
    }];
    [self.disConnectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hostTextField.mas_bottom).offset(20);
        make.left.mas_equalTo(self.connectButton.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [self.messageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.connectButton.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.size.mas_equalTo(CGSizeMake(180, 55));
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.messageTextField);
        make.left.mas_equalTo(self.messageTextField.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(55, 30));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageTextField.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
        make.height.mas_equalTo(100);
    }];
}

#pragma mark - Custom Accessors

- (JVFloatLabeledTextField *)hostTextField {
    if (!_hostTextField) {
        _hostTextField = [[JVFloatLabeledTextField alloc] init];
        _hostTextField.font = [UIFont systemFontOfSize:18.0f];
        _hostTextField.floatingLabelTextColor = _themeColor;
        _hostTextField.floatingLabelActiveTextColor = _themeColor;
        [_hostTextField setPlaceholder:@"请输入主机地址" floatingTitle:@"主机地址"];
        _hostTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _hostTextField.layer.borderWidth = 1;
        _hostTextField.layer.borderColor = _themeColor.CGColor;
        _hostTextField.layer.cornerRadius = 3.0f;
        _hostTextField.layer.masksToBounds = YES;
    }
    return  _hostTextField;
}

- (JVFloatLabeledTextField *)portTextField {
    if (!_portTextField) {
        _portTextField = [[JVFloatLabeledTextField alloc] init];
        _portTextField.font = [UIFont systemFontOfSize:18.0f];
        _portTextField.floatingLabelTextColor = _themeColor;
        _portTextField.floatingLabelActiveTextColor = _themeColor;
        [_portTextField setPlaceholder:@"请输入端口" floatingTitle:@"端口"];
        _portTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _portTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _portTextField.layer.borderWidth = 1;
        _portTextField.layer.borderColor = _themeColor.CGColor;
        _portTextField.layer.cornerRadius = 3.0f;
        _portTextField.layer.masksToBounds = YES;
    }
    return  _portTextField;
}

- (JVFloatLabeledTextField *)messageTextField {
    if (!_messageTextField) {
        _messageTextField = [[JVFloatLabeledTextField alloc] init];
        _messageTextField.font = [UIFont systemFontOfSize:18.0f];
        _messageTextField.floatingLabelTextColor = _themeColor;
        _messageTextField.floatingLabelActiveTextColor = _themeColor;
        [_messageTextField setPlaceholder:@"请输入发送消息" floatingTitle:@"消息"];
        _messageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _messageTextField.layer.borderWidth = 1;
        _messageTextField.layer.borderColor = _themeColor.CGColor;
        _messageTextField.layer.cornerRadius = 3.0f;
        _messageTextField.layer.masksToBounds = YES;
    }
    return  _messageTextField;
}

- (UIButton *)connectButton {
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 默认标题
        NSDictionary *normalAttrs = @{
            NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
            NSForegroundColorAttributeName: UIColor.whiteColor
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"连接" attributes:normalAttrs];
        [_connectButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        
        // 高亮标题
        NSDictionary *highlightedAttrs = @{
            NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
            NSForegroundColorAttributeName: _themeColor
        };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"连接" attributes:highlightedAttrs];
        [_connectButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        
        // 背景颜色
        [_connectButton jk_setBackgroundColor:_themeColor forState:UIControlStateNormal];
        [_connectButton jk_setBackgroundColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        
        // 圆角和边框
        _connectButton.layer.cornerRadius = 3.0f;
        _connectButton.layer.masksToBounds = YES;
        _connectButton.layer.borderWidth = 1.0f;
        _connectButton.layer.borderColor = _themeColor.CGColor;
        
        [_connectButton addTarget:self action:@selector(connectToServer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectButton;
}

- (UIButton *)disConnectButton {
    if (!_disConnectButton) {
        _disConnectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 默认标题
        NSDictionary *normalAttrs = @{
            NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
            NSForegroundColorAttributeName: _themeColor
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"断开连接" attributes:normalAttrs];
        [_disConnectButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        
        // 高亮标题
        NSDictionary *highlightedAttrs = @{
            NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
            NSForegroundColorAttributeName: [UIColor whiteColor]
        };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"断开连接" attributes:highlightedAttrs];
        [_disConnectButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        
        // 高亮背景颜色
        [_disConnectButton jk_setBackgroundColor:_themeColor forState:UIControlStateHighlighted];
        
        // 圆角和边框
        _disConnectButton.layer.cornerRadius = 3.0f;
        _disConnectButton.layer.masksToBounds = YES;
        _disConnectButton.layer.borderWidth = 1.0f;
        _disConnectButton.layer.borderColor = _themeColor.CGColor;
        
        [_connectButton addTarget:self action:@selector(disconnectToServer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _disConnectButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 默认标题
        NSDictionary *normalAttrs = @{
            NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
            NSForegroundColorAttributeName: UIColor.whiteColor
        };
        NSAttributedString *normalTitle = [[NSAttributedString alloc] initWithString:@"发送" attributes:normalAttrs];
        [_sendButton setAttributedTitle:normalTitle forState:UIControlStateNormal];
        
        // 高亮标题
        NSDictionary *highlightedAttrs = @{
            NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
            NSForegroundColorAttributeName: _themeColor
        };
        NSAttributedString *highlightedTitle = [[NSAttributedString alloc] initWithString:@"发送" attributes:highlightedAttrs];
        [_sendButton setAttributedTitle:highlightedTitle forState:UIControlStateHighlighted];
        
        // 背景颜色
        [_sendButton jk_setBackgroundColor:_themeColor forState:UIControlStateNormal];
        [_sendButton jk_setBackgroundColor:UIColor.whiteColor forState:UIControlStateHighlighted];
        
        // 圆角和边框
        _sendButton.layer.cornerRadius = 3.0f;
        _sendButton.layer.masksToBounds = YES;
        _sendButton.layer.borderWidth = 1.0f;
        _sendButton.layer.borderColor = _themeColor.CGColor;
        
        [_connectButton addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = UIColor.systemGray5Color;
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
        _contentLabel.textColor = UIColor.darkTextColor;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (NSMutableString *)logs {
    if (!_logs) {
        _logs = [[NSMutableString alloc] init];
    }
    return _logs;
}

#pragma mark - Actions

/// 连接服务器
- (void)connectToServer:(id)sender {
    // 校验输入的 IP 地址和端口是否正确
    NSString *ipAddress = self.hostTextField.text;
    NSString *port = self.portTextField.text;
    NSString *regex = @"((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))";
    BOOL isIPAddressValidate = [ipAddress jk_matchWithRegex:regex];
    BOOL isPortValidate = [port jk_matchWithRegex:@"^\\d{1,5}$"];
    if (!isIPAddressValidate || !isPortValidate) {
        [self.navigationController.view jk_makeToast:@"主机地址或端口输入错误"];
        return;
    }
    
    [self.logs appendString:[NSString stringWithFormat:@"服务器IP:%@:%@\n", ipAddress, port]];
    self.contentLabel.text = self.logs;
    
    // 连接服务器
    NSError *error;
    BOOL isConnect = [_clientSocket connectToHost:ipAddress onPort:port.intValue error:&error];
    if (isConnect) {
        NSLog(@"socket 连接成功01");
    } else {
        NSLog(@"socket 连接失败: %@",error);
    }
}

/// 断开连接
- (void)disconnectToServer:(id)sender {
    if (_clientSocket.isConnected) {
        [_clientSocket disconnect];
    }
}

/// 发送消息
- (void)sendMessageAction:(id)sender {
    
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

#pragma mark - GCDAsyncSocketDelegate

// 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
   NSLog(@"socket 连接成功02");
    
    // TODO: 定时发送心跳包
    // ...
    
    // 读取数据，必须添加，相当于主动添加一个读取请求，不然不会执行读取信息回调方法
    [_clientSocket readDataWithTimeout:-1 tag:0];
}

// 已经断开链接
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"socket 断开连接%@",err.localizedDescription);
    
    // TODO: 如果是意外断开，执行断开重连
    // ...
}

//读取到数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    // 注意：要想长连接，必须还要在 DidReceiveData 的 delegate 中再写一次 [_clientSocket receiveOnce:&error]
    // 读取数据，读取完信息后，重新向队列中添加一个读取请求，不然当收到信息后不会执行读取回调方法。
   [_clientSocket readDataWithTimeout:-1 tag:0];

    NSData *head = [data subdataWithRange:NSMakeRange(0, 3)];//取得头部数据
    NSData *tagData = [head subdataWithRange:NSMakeRange(0, 1)];
    NSString *hexString = [tagData convertDataToHexStr];

    if([hexString isEqual:@"01"]) {

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

    if([hexString isEqual:@"02"]) {

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
