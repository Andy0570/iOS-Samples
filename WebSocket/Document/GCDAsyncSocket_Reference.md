> 原文：<https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Reference_GCDAsyncSocket>

GCDAsyncSocket 是基于 Grand Central Dispatch 构建的 TCP 套接字网络库。该项目还包含一个基于 RunLoop 的版本，以及 UDP 套接字库。

CocoaAsyncSocket 项目是一个成熟的开源框架，自 2003 年以来一直存在。因此，它已经受益于广泛的网络开发人员，他们已经提交了代码或建议的功能。该项目的目标是创建强大而易用的套接字库。

GCDAsyncSocket 的特性包括:

* 原生 Objective-C 实现，完全独立在一个类之中。
  *不需要与 socket 或 stream 混在一起。这个类为您处理所有事情*。
* 完整的 delegate 支持
  *错误、连接、读完成、写完成、进度和断开连接都会调用委托方法*。
* 队列和非阻塞读写，带有可选的超时选项。
  *你告诉它读什么或写什么，它会为你处理一切事情。在自动处理的流中自动排队、缓冲和搜索终止序列*。
* 自动接收 socket。
  *启动一个 socket 服务，告诉它接受连接，它会为每个连接调用自己的新实例*。
* 支持 IPv4 及 IPv6 上的 TCP 流。
  *自动连接到 IPv4 或 IPv6 主机。使用这个类的一个实例自动接受通过 IPv4 和 IPv6 传入的连接。不用再担心多个 socket*。
* 支持 TLS/SSL。
  只使用一个方法调用就可以轻松地保护您的 socket。支持客户端和服务端 socket。
* 完全基于 GCD 和线程安全
  它完全在它自己的 GCD `dispatch_queue` 中运行，并且是完全线程安全的。此外，委托方法全部异步调用到您选择的 `dispatch_queue` 上。这意味着它可以并行执行你的 socket 代码和委托/处理代码。

GCDAsyncSocket 的一个比较强大的功能是它的队列架构。这允许您在方便的时候控制套接字，而不是当套接字告诉您它准备好了。举几个例子。

```objc
// 开始异步连接。
// 下面的方法将立即返回。
// 并且委托方法socket:didConnectToHost:port:将在连接完成后被调用。
[asyncSocket connectToHost:host onPort:port error:nil];

// 此时此刻，套接字还没有连接。
// 它刚刚开始异步连接尝试。
// 但 AsyncSocket 的设计是为了让你更容易地进行套接字编程。
// 如果你方便的话，你可以自由地开始读/写。
// 所以我们现在要开始读取消息头的请求。
// 读取请求会自动排队。
// 当套接字连接后，这个读取请求将自动被去掉队列并执行。
[asyncSocket readDataToLength:LENGTH_HEADER withTimeout:TIMEOUT_NONE tag:TAG_HEADER];
```

除此之外，你还可以根据方便调用多个读写请求。

```objc
// 开始异步写操作
[asyncSocket writeData:msgHeader withTimeout:TIMEOUT_NONE tag:TAG_HEADER];

// 我们不需要等待写完后再开始下一次写
[asyncSocket writeData:msgBody withTimeout:TIMEOUT_NONE tag:TAG_BODY];
```

```objc
// 开始异步读取操作。
// 读取并忽略欢迎信息。
[asyncSocket readDataToData:msgSeparator withTimeout:TIMEOUT_NONE tag:TAG_WELCOME];

// 我们不必等待该次读取完成后再开始下一次读取。
// 读取服务器能力。
[asyncSocket readDataToData:msgSeparator withTimeout:TIMEOUT_NONE tag:TAG_CAPABILITIES];
```

队列式架构甚至延伸到SSL/TLS支持!

```objc
// Send startTLS confirmation ACK.
// Remember this is an asynchronous operation.
[asyncSocket writeData:ack withTimeout:TIMEOUT_NONE tag:TAG_ACK];

// We don't have to wait for the write to complete before invoking startTLS.
// The socket will automatically queue the operation, and wait for previous reads/writes to complete.
// Once that has happened, the upgrade to SSL/TLS will automatically start.
[asyncSocket startTLS:tlsSettings];

// Again, we don't have to wait for the security handshakes to complete.
// We can immediately queue our next operation if it's convenient for us.
// So we can start reading the next request from the client.
// This read will occur over a secure connection.
[asyncSocket readDataToData:msgSeparator withTimeout:TIMEOUT_NONE tag:TAG_MSG];
```

超时（Timeouts）是大多数操作的可选参数。

除此之外，你可能已经注意到了标签参数。读/写操作中传递的标签会在读/写操作完成后通过委托方法传回给你。它不会通过套接字发送或从套接字中读取。它的设计是为了帮助简化您的委托方法中的代码。例如，你的委托方法可能是这样的。

```objc
#define TAG_WELCOME 10
#define TAG_CAPABILITIES 11
#define TAG_MSG 12

... 

- (void)socket:(AsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == TAG_WELCOME)
    {
        // Ignore welcome message
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

GCDAsyncSocket是线程安全的。

## License

这个类是在公共领域。

最初由 Robbie Hanson 在 2010 年第三季度创建。

由 Deusty Designs 和 Mac 开发社区更新和维护。

## Reference

...

---


创建 socket 方法：

```objc
/** 
 * GCDAsyncSocket 使用标准的委托模式。
 * 但会在给定的委托队列上执行所有的委托回调。
 * 这可以允许最大的并发性，同时提供简单的线程安全。
 * 
 * 您必须先设置一个委托和委托队列，然后再尝试使用 socket，否则你会得到一个错误。
 * 
 * socket 队列是可选的
 * 如果传递 NULL，GCDAsyncSocket 将自动创建自己的 socket 队列。
 * 如果你选择自己提供一个 socket 队列，那么该 socket 队列必须不是一个并发队列。
 * 如果选择提供一个 socket 队列，并且 socket 队列有一个配置的 target 队列，那么GCDAsyncSocket 将自动创建自己的套接字队列。
 * 那么请看 markSocketQueueTargetQueue 方法的讨论。
 * 
 * 委托队列和 socket 队列可以选择使用相同的队列。
 **/
- (instancetype)init;
- (instancetype)initWithSocketQueue:(nullable dispatch_queue_t)sq;
- (instancetype)initWithDelegate:(nullable id<GCDAsyncSocketDelegate>)aDelegate delegateQueue:(nullable dispatch_queue_t)dq;
- (instancetype)initWithDelegate:(nullable id<GCDAsyncSocketDelegate>)aDelegate delegateQueue:(nullable dispatch_queue_t)dq socketQueue:(nullable dispatch_queue_t)sq NS_DESIGNATED_INITIALIZER;
```

当 socket 断开连接时被调用：

```objc
/**
 * 当 socket 断开连接时调用，可能有错误，可能没有错误。
 * 
 * 如果你调用 disconnect 方法，而 socket 还没有被断开。
 * 那么对该委托方法的调用将被列入委托人队列（delegateQueue）。
 * 在断开方法返回之前。
 * 
 * 注意：如果 GCDAsyncSocket 实例在连接时被 deallocated，
 * 而同时 delegate 没有被 deallocated，那么这个方法也会被调用。
 * 但回调方法中的 sock 参数将是nil。(它必须是 nil，因为它已经不可用了)。
 * 这种情况一般很少见，但如果写这样的代码是可能的。
 * 
 * asyncSocket = nil; // 我隐含地断开了 socket 连接。
 * 
 * 在这种情况下，最好事先将 delegate  作废，比如这样。
 * 
 * asyncSocket.delegate = nil; // 不要调用我的 delegate 方法。
 * asyncSocket = nil; // 我隐含地断开了 socket 连接。
 * 
 * 当然，这取决于你的状态机是如何配置的。
**/
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err;
```

读取数据的几个方法：

```objc
//读取数据，有数据就会触发代理
- (void)readDataWithTimeout:(NSTimeInterval)timeout tag:(long)tag;
// 读取指定长度的数据，才会触发代理
- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag;
// 读取到指定 data 边界，才会触发代理
- (void)readDataToData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
```
