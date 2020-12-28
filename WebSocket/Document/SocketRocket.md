GitHub 源码： [facebookarchive/SocketRocket](https://github.com/facebookarchive/SocketRocket)

SocketRocket 是一个遵循 WebSocket（[RFC 6455](https://tools.ietf.org/html/rfc6455)）的适用于 iOS、macOS 和 tvOS 的客户端库。

## 特性/设计

* 支持 TLS (wss)，包括自签名证书。
* 看起来表现不错。
* 支持 HTTP 代理。
* 支持 IPv4/IPv6。
* 支持 SSL 证书锁定（SSL certificate pinning）。
* 发送 `ping` 和处理 `pong` 事件。
* 异步和非阻塞。大多数工作是在后台线程上完成的。
* 支持 iOS，macOS，tvOS。

注：证书锁定（SSL/TLS Pinning）顾名思义，将服务器提供的 SSL/TLS 证书内置到移动端开发的 APP 客户端中，当客户端发起请求时，通过比对内置的证书和服务器端证书的内容，以确定这个连接的合法性。



## API

### `SRWebSocket`

Web Socket.

**注意：**

`SRWebSocket` 将在 `-(void)open` 和它被关闭、发生错误或者失败之间保留自身。这类似于 `NSURLConnection` 的行为(与 `NSURLConnection` 不同的是，`SRWebSocket` 不会保留委托)。

**接口**

```objc
@interface SRWebSocket : NSObject <NSStreamDelegate>

// 在执行 open 之前设置这个
@property (nonatomic, weak) id <SRWebSocketDelegate> delegate;

@property (nonatomic, readonly) SRReadyState readyState;
@property (nonatomic, readonly, retain) NSURL *url;


@property (nonatomic, readonly) CFHTTPMessageRef receivedHTTPHeaders;

// Optional array of cookies (NSHTTPCookie objects) to apply to the connections
@property (nonatomic, readwrite) NSArray * requestCookies;

// This returns the negotiated protocol.
// It will be nil until after the handshake completes.
@property (nonatomic, readonly, copy) NSString *protocol;

// 协议应该是一个字符串数组，这些字符串转换成 Sec-WebSocket-Protocol
- (id)initWithURLRequest:(NSURLRequest *)request protocols:(NSArray *)protocols allowsUntrustedSSLCertificates:(BOOL)allowsUntrustedSSLCertificates;
- (id)initWithURLRequest:(NSURLRequest *)request protocols:(NSArray *)protocols;
- (id)initWithURLRequest:(NSURLRequest *)request;

// 辅助构造函数
- (id)initWithURL:(NSURL *)url protocols:(NSArray *)protocols allowsUntrustedSSLCertificates:(BOOL)allowsUntrustedSSLCertificates;
- (id)initWithURL:(NSURL *)url protocols:(NSArray *)protocols;
- (id)initWithURL:(NSURL *)url;

// Delegate queue will be dispatch_main_queue by default.
// You cannot set both OperationQueue and dispatch_queue.
- (void)setDelegateOperationQueue:(NSOperationQueue*) queue;
- (void)setDelegateDispatchQueue:(dispatch_queue_t) queue;

// By default, it will schedule itself on +[NSRunLoop SR_networkRunLoop] using defaultModes.
- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;
- (void)unscheduleFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode;

// SRWebSockets 仅用于一次性使用。应该只调用一次 Open。
- (void)open;

- (void)close;
- (void)closeWithCode:(NSInteger)code reason:(NSString *)reason;

// Send a UTF8 String or Data.
- (void)send:(id)data;

// Send Data (can be nil) in a ping message.
- (void)sendPing:(NSData *)data;

@end
```



### `SRWebSocketDelegate`

```objc
@protocol SRWebSocketDelegate <NSObject>

// didReceiveMessage 方法是必须实现的，用来接收消息。
// 如果服务器使用 text 文本，则消息为 NSString 类型; 
// 如果服务器使用 binary 二进制，则消息为 NSData 类型。
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;

@optional

// 下面 4 个 did 方法分别对应着 Open，Fail，Close，ReceivePong 不同状态的代理方法
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;

// 返回 YES 则将作为 Text 发送的消息转换为 NSString 类型。
// 返回 NO 以跳过文本消息的 NSData-> NSString 转换。默认为 YES。
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket;

@end
```



**关于 `didReceivePong` 消息**

使用 Web Socket 时，最好建立一个心跳包，用于每隔一段时间（5s 也好十几秒也好）通知一次服务端，告诉服务器，客户端还活着，这就是一个 ping 消息。然后，服务器返回给客户端一个 pong 消息，这个 pong 消息就在 `didReceivePong` 这个代理方法中去接收。

```objc
// Send a UTF8 String or Data.
- (void)send:(id)data;
```

> 国内移动无线网络运营商在链路上一段时间内没有数据通讯后，会淘汰 NAT 表中的对应项，造成链路中断。而国内的运营商一般 NAT 超时的时间为 5 分钟，所以通常我们心跳设置的时间间隔为 3-5 分钟。

在发送信息的时候，要和服务器进行商量，格式是什么样的，如果格式不对的话，每发送一次，Web Socket 都会关闭一次，这就很蛋疼了。
发送消息的时候，最好是创建一个模型 -> 转字典 -> 转 data-> 转成字符串。最后发送给服务器的就是这个字符串了。

```objc
XQMessage* message = [[XQMessage alloc] initWithMessage:textField.text userId: userTextField.text];
NSError* error;
NSData* data = [NSJSONSerialization dataWithJSONObject:message.mj_keyValues options:0 error:&error];    
[self.wSocket send:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
```

在接收到消息 `didReceiveMessage` 的方法中，再把服务器传过来的数据，转换成模型，方便使用。

学会了简单的使用 socketRocket 之后，最好封装一个工具类，来进行统一的管理，外界方便使用调用。需要注意的事，在封装的过程中，要定义一个属性 state，表示 websocket 的连接状态，是关闭？连接中？已连接？连接错误？系统关闭？用户关闭？接收到信息等。根据实际的需求去做一些相应的处理。
