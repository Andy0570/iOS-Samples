> 原文：<https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Intro_GCDAsyncSocket>

GCDAsyncSocket 是一个 TCP 库。它建立在 Grand Central Dispatch 之上。

本页提供了该库的介绍。

## 初始化

最常见的初始化实例的方法简单来说就是这样：

```objc
socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
```

为了让 GCDAsyncSocket 调用你（遵守）的委托方法，需要 delegate 和 delegate_queue。上面的代码中指定 `self` 为遵守委托的对象，并指示库在主线程上调用所有的委托方法。

设置一个 delegate 可能是一个熟悉的操作。然而，提供一个 delegateQueue 可能是一个新概念。大多数典型的库都是单线程的。当需要调用 delegate 方法时，他们只是调用它。这些库假设你的 delegate 代码也是单线程的。或者，库的内部可能是多线程的，但它们假设你的 delegate 代码是单线程的，并且设计成只在主线程上运行。所以它们只是总是在主线程上调用所有的委托方法。

而 GCDAsyncSocket 则是为性能而设计的。它允许你在你选择的专用 GCD 队列上接收委托回调。这使得它可以在高性能服务器中使用，并且可以支持成千上万的并发连接。但在典型的应用中它也有帮助。想让你的 UI 更敏捷一点吗？有没有考虑过将网络处理代码从 UI 线程上移开？即使是今天的移动设备也有多个 CPU 内核......也许是时候开始利用它们了。

## 配置

大多数时候你不需要配置。有各种配置选项（如头文件中所述），但它们主要是针对高级用例。

注意：安全（TLS/SSL）是你以后设置的东西。这些协议实际上运行在TCP之上（它们不是TCP本身的一部分）。

## 连接

最常见的连接方式是：

```objc
NSError *err = nil;
if (![socket connectToHost:@"deusty.com" onPort:80 error:&err]) // 异步的!
{
    // 如果有错误，很可能是 "已经连接" 或 "没有设置委托" 之类的问题。
    NSLog(@"I goofed: %@", err);
}
```

连接方法是异步的。这意味着什么？这意味着当你调用 connect 方法时，它们会开启一个后台操作来连接到所需的主机/端口，然后立即返回。这个异步的后台操作最终要么成功，要么失败。无论哪种方式，相关的委托方法都会被调用。

```objc
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Cool, I'm connected! That was easy.");
}
```

那么如果 connect 方法是异步的，为什么会返回一个布尔值和错误呢？只有当一些明显的事情阻止它开始连接操作时，这个方法才会返回NO。例如，如果 socket 已经被连接，或者从未设置过 delegate。

实际上有几种不同的连接方法供你使用。它们为你提供了不同的选项，例如

* 可选择指定一个连接超时。
  *例如：如果5秒内没有连接，则失败*。
* 可选择指定要连接的接口（interface）
  *例如，使用蓝牙连接，或使用 WiFi 连接，无论是否有有线连接*。
* 提供一个原始的 socket 地址，而不是名称/端口对。
  *如：我用 `NSNetService` 解析了一个地址，而我只想连接到这个地址*。

## 读和写

该库最大的特点之一是 "队列读/写操作"。什么叫 "队列读写 "呢？一个简单的代码例子可能是最好的解释：

```objc
NSError *err = nil;
if (![socket connectToHost:@"deusty.com" onPort:80 error:&err]) // 异步的!
{
    // 如果有错误，很可能是 "已经连接" 或 "没有设置委托" 之类的问题。set"
    NSLog(@"I goofed: %@", err);
    return;
}

// 此时 socket 未连接。
// 但我还是可以开始向它写入东西!
// 该库会将我所有的写入操作排成队列。
// 然后在 socket 连接后，它会自动开始执行我的写入方法!
[socket writeData:request1 withTimeout:-1 tag:1];

// 事实上，我知道我有两个请求。
// 为什么不现在就把它们都解决掉呢？
[socket writeData:request2 withTimeout:-1 tag:2];

// 哼，趁着现在，我还不如排队阅读，争取第一时间回复。
[socket readDataToLength:responseHeaderLength withTimeout:-1 tag:TAG_RESPONSE_HEADER];
```

你可能已经注意到了 `tag` 参数。那是什么意思？嗯，这都是为了方便你。你指定的 `tag` 参数不会通过 socket 发送，也不会从 socket 中读取。`tag` 参数只是通过各种委托方法回传给你。它的设计是为了帮助您简化委托方法中的代码。

```objc
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (tag == 1)
        NSLog(@"发出第一个请求");
    else if (tag == 2)
        NSLog(@"发出第二个请求");
}
```

Tag 对读取操作的帮助最大：

```objc
#define TAG_WELCOME 10
#define TAG_CAPABILITIES 11
#define TAG_MSG 12

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == TAG_WELCOME)
    {
        // 忽略欢迎消息
    }
    else if (tag == TAG_CAPABILITIES)
    {
        [self processCapabilities:data];
    }
    else if (tag == TAG_MSG)
    {
        [self processMessage:data];
    }
}
```

你看，TCP 协议是以无限长的**单一连续流**的概念为模型的。理解这一点至关重要--事实上，这也是我们所看到的**造成混乱的首要原因**。

想象一下，你正试图通过套接字发送一些消息。所以你做了这样的事情（在伪代码中）：

```objc
socket.write("Hi Sandy.");
socket.write("Are you busy tonight?");
```

数据如何在另一端显示出来？如果你认为另一端会在两个独立的读取操作中收到两个独立的句子，那么你刚刚中了一个常见的陷阱! 惊呼! 但不要害怕! 你的情况并没有生命危险，只是普通的感冒而已。通过阅读 "[常见陷阱](https://github.com/robbiehanson/CocoaAsyncSocket/wiki/CommonPitfalls) "页面，可以找到治疗方法。

既然说到这里，你可能想知道哪些读取方法。下面就给大家介绍几种。

```objc
- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)readDataToData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
```

第一个方法，`readDataToLength`，读取并返回给定长度的数据。让我们来看一个例子。

你正在编写一个协议的客户端侧，服务器发送带有固定长度头的响应。所有响应的头正好是8个字节。前4个字节包含各种标志等。而后4个字节包含响应数据的长度，是可变的。所以你的代码可能是这样的。

```objc
- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == TAG_FIXED_LENGTH_HEADER)
    {
        int bodyLength = [self parseHeader:data];
        [socket readDataToLength:bodyLength withTimeout:-1 tag:TAG_RESPONSE_BODY];
    } 
    else if (tag == TAG_RESPONSE_BODY)
    {
        // Process the response
        [self handleResponseBody:data];

        // Start reading the next response
        [socket readDataToLength:headerLength withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
    }
}
```

让我们看看另一个例子。毕竟，不是所有的协议都使用固定长度的头。HTTP 就是这样一个协议。

一个典型的 HTTP 响应看起来像这样。

```http
HTTP/1.1 200 OK
Date: Thu, 24 Nov 2011 02:18:50 GMT
Server: Apache/2.2.3 (CentOS)
X-Powered-By: PHP/5.1.6
Content-Length: 5233
Content-Type: text/html; charset=UTF-8
```

这只是一个例子。可以有任何数量的头字段。换句话说，HTTP 头的长度是可变的。我们如何读取它？

好吧，HTTP 协议解释了如何。头部的每一行都以 CRLF（回车，换行："\r\n"）结束。此外，头的结尾用2个背对背的CRLF标记。而正文的长度则是通过 "Content-Length "头域来指定的。所以我们可以这样做。

```objc
- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == HTTP_HEADER)
    {
        int bodyLength = [self parseHttpHeader:data];
        [socket readDataToLength:bodyLength withTimeout:-1 tag:HTTP_BODY];
    }
    else if (tag == HTTP_BODY)
    {
        // Process response
        [self processHttpBody:data];

        // 读取下一个响应头
        NSData *term = [@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding];
        [socket readDataToData:term withTimeout:-1 tag:HTTP_HEADER];
    }
}
```

我已经列出了 2 种可用的读取方法。有近10种不同的读取方法。它们提供了更多的高级选项，如指定最大长度，或提供你自己的读取缓冲区。

## 编写服务器

`GCDAsyncSocket` 还允许你创建一个服务器，并接受传入的连接。它看起来像这样：

```objc
listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

NSError *error = nil;
if (![listenSocket acceptOnPort:port error:&error])
{
    NSLog(@"I goofed: %@", error);
}

- (void)socket:(GCDAsyncSocket *)sender didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    // The "sender" parameter is the listenSocket we created.
    // The "newSocket" is a new instance of GCDAsyncSocket.
    // It represents the accepted incoming client connection.

    // Do server stuff with newSocket...
}
```

就这么简单! 更具体的例子，请查看存储库中的 "EchoServer" 示例项目。