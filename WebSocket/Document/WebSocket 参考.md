## 套接字（Socket）

应用在使用 TCP 或 UDP 时，会用到操作系统提供的类库。这种类库一般被称为 API（Application Programming Interface，应用程序编程接口）。
使用 TCP 或 UDP 通信时，又会广泛使用到套接字（socket）的 API。套接字原本是由 BSD UNIX 开发的，但是后来被移植到了 Windows 的 Winsock 以及嵌入式操作系统中。
应用程序利用套接字，可以设置对端的 IP 地址、端口号，并实现数据的发送与接收。

——摘自 [图解 TCP/IP](https://book.douban.com/subject/24737674/)（Page 196）

---

Socket 是对 TCP/IP 协议的封装，Socket 本身并不是协议，而是一个调用接口（API）。

它工作在 OSI 参考模型的会话层（第 5 层），是为了方便大家直接使用更底层协议（一般是 TCP 或 UDP 协议）而存在的一个抽象层。

在设计模式中，Socket 其实就是一个门面模式，它把复杂的 TCP/IP 协议族隐藏在 Socket 接口后面，对使用用户来说，一组简单的接口就是一律让 Socket 去组织数据，以符合指定的协议。当两台主机通信时，必需通过 Socket 连接，Socket 则使用 TCP/IP 协议建立 TCP 连接。TCP 连接则更依靠于底层的 IP 协议，IP 协议的连接则依赖于链路层等更低层次。

Socket 通常也称作“套接字”，用于描述 IP 地址和端口，是一个通信链的句柄。网络上的两个程序通过一个双向的通讯连接实现数据的交换，这个双向链路的一端称为一个 Socket，一个 Socket 由一个 IP 地址和一个端口号唯一确定。应用程序通常通过“套接字” 向网络发出请求或者应答网络请求。

Socket 在通讯过程中，服务端监听某个端口是否有连接请求，客户端向服务端发送连接请求，服务端收到连接请求向客户端发出接收消息，这样一个连接就建立起来了。客户端和服务端也都可以相互发送消息与对方进行通讯，直到双方连接断开。

基于 WebSocket 和基于 Socket 都可以开发出 IM 社交聊天类的 app。

![](https://static01.imgkr.com/temp/a8fb3308132f46678a280e096ed64002.png)



## WebSocket

WebSocket 是应用层第 7 层上的一个**应用层协议**，它必须依赖 HTTP 协议进行一次握手，握手成功后，数据就直接从 TCP 通道传输，与 HTTP 无关了。 

WebSocket 的数据传输是以数据帧（`frame`）形式传输的，比如会将一条消息分为几个 `frame`，按照先后顺序传输出去。这样做会有几个好处： 

1. 大数据的传输可以分片传输，不用考虑到数据大小导致的长度标志位不足够的情况。 
2. 和 http 的 chunk 一样，可以边生成数据边传递消息，即提高传输效率。

---

WebSocket 是 HTML5 标准的一个新的 [网络协议](https://www.jmjc.tech/tutorial/python/51)。它是基于 HTTP 协议之上的扩展，是一种可以`双向通信`的协议。

传统的 [HTTP 协议](https://www.jmjc.tech/tutorial/python/54) 通信，服务端是不能主动发信息给客户端的。它必须是客户端一个请求，服务器一个响应，一来一回。那么基于这种通信的方式，如果想构建一个网络在线聊天应用，就没有办法，因为不能主动推送信息，要客户端一直刷新。

websocket 可以跟 HTTP 协议共用一个端口，它协议的前缀是 `ws://`，如果是 HTTPS，那么就是 `wss://`，webSocket 没有同源限制，客户端可以发送任意请求到服务端，只要目标服务器允许。

——[Node.js WebSocket 协议](https://www.jmjc.tech/less/114)

---

**WebSocket 的设计与功能**

WebSocket，即 Web 浏览器与 Web 服务器之间全双工通信标准。其中，WebSocket 协议由 IETF 定为标准，WebSocket API 由 W3C 定为标准。仍在开发中的 WebSocket 技术主要是为了解决 Ajax 和 Comet 里 `XMLHttpRequest` 附带的缺陷所引起的问题。

**WebSocket 协议**

一旦 Web 服务器与客户端之间建立起 WebSocket 协议的通信连接，之后所有的通信都依靠这个专用协议进行。通信过程中可互相发送 JSON、XML、HTML 或图片等任意格式的数据。

由于是建立在 HTTP 基础上的协议，因此连接的发起方仍是客户端， 而一旦确立 WebSocket 通信连接，不论服务器还是客户端，任意一方都可直接向对方发送报文。

**WebSocket 的主要特点**

推送功能：支持由服务器向客户端推送数据的推送功能。这样，服务器可直接发送数据，而不必等待客户端的请求。

减少通信量：只要建立起 WebSocket 连接，就希望一直保持连接状态。和 HTTP 相比，不但每次连接时的总开销减少，而且由于 WebSocket 的首部信息很小，通信量也相应减少了。

**WebSocket 握手请求**

为了实现 WebSocket 通信，在 HTTP 连接建立之后，需要完成一 次“握手”（Handshaking）的步骤。

为了实现 WebSocket 通信，需要用到 HTTP 的 `Upgrade` 首部字段，告知服务器通信协议发生改变，以达到握手的目的。

```http
GET /chat HTTP/1.1 
Host: server.example.com 
Upgrade: websocket 
Connection: Upgrade 
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ== 
Origin: http://example.com 
Sec-WebSocket-Protocol: chat, superchat 
Sec-WebSocket-Version: 13
```

`Sec-WebSocket-Key` 字段内记录着握手过程中必不可少的键值。 `Sec-WebSocket-Protocol` 字段内记录使用的子协议。

子协议按 WebSocket 协议标准在连接分开使用时，定义那些连接的名称。

**WebSocket 握手响应**

对于之前的请求，返回状态码 `101 Switching Protocols` 的响应。

```
HTTP/1.1 101 Switching Protocols 
Upgrade: websocket 
Connection: Upgrade 
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo= 
Sec-WebSocket-Protocol: chat
```

`Sec-WebSocket-Accept` 的字段值是由握手请求中的 `SecWebSocket-Key` 的字段值生成的。 

成功握手确立 WebSocket 连接之后，通信时不再使用 HTTP 的数据帧，而采用 WebSocket 独立的数据帧。

——摘自《[图解 HTTP](https://book.douban.com/subject/25863515/)》P176～178

---

### 相关文档

* [RFC 6455: The WebSocket Protocol](https://tools.ietf.org/html/rfc6455)
* [GitBook: WebSocket 协议](http://doc.workerman.net/appendices/about-websocket.html)

### WebSocket 的特点

Socket 是**传输控制层协议**，WebSocket 是**应用层协议**。
WebSocket 可以传输文本和二进制。
WebSocket 的协议头是 ws 开头的，并不是 http。

### WebSocket 和 HTTP 协议

WebSocket 是 HTML5 开始提供的一种在单个 TCP 连接上进行**全双工通讯**的协议。

HTTP 协议是一种无状态的、无连接的、单向的应用层协议。它采使用了请求/响应模型。通信请求只能由客户端发起，服务端对请求做出应答解决。这种通信模型有一个弊端：**HTTP 协议无法实现服务器主动向客户端发起消息**。这种单向请求的特点，注定了假如服务器有连续的状态变化，客户端要获知就非常麻烦。大多数 Web 应使用程序将通过频繁的异步 JavaScript 和 XML（AJAX）请求实现长轮询。轮询的效率低，非常白费资源（由于必须不停连接，或者 HTTP 连接始终打开）。

WebSocket 连接允许用户端和服务器之间进行**全双工通信**，以便任一方都可以通过建立的连接将数据推送到另一端。WebSocket 只要要建立一次连接，即可以一直保持连接状态。这相比于轮询方式的不停建立连接显然效率要大大提高。

### 什么是心跳

简单的来说，心跳就是用来检测 TCP 连接的双方是否可用。那又会有人要问了，TCP 不是本身就自带一个 KeepAlive 机制吗？ 这里我们需要说明的是 TCP 的 KeepAlive 机制只能保证连接的存在，但是并不能保证客户端以及服务端的可用性。我们客户端发起心跳 Ping（一般都是客户端），假如设置在 10 秒后如果没有收到回调，那么说明服务器或者客户端某一方出现问题，这时候我们需要主动断开连接。 服务端也是一样，会维护一个 socket 的心跳间隔，当约定时间内，没有收到客户端发来的心跳，我们会知道该连接已经失效，然后主动断开连接。 国内移动无线网络运营商在链路上一段时间内没有数据通讯后，会淘汰 NAT 表中的对应项，造成链路中断。而国内的运营商一般 NAT 超时的时间为 5 分钟，所以通常我们心跳设置的时间间隔为 3-5 分钟。

### 什么是 PingPong 机制

![](https://static01.imgkr.com/temp/2f6224185651404391921ba6456c2d1c.png)

当服务端发出一个 Ping，客户端没有在约定的时间内返回响应的 ack，则认为客户端已经不在线，这时 Server 端会主动断开 Scoket 连接，并且改由 APNs 推送的方式发送消息。同样的是，当客户端去发送一个消息，因为我们迟迟无法收到服务端的响应 ack 包，则表明客户端或者服务端已不在线，我们也会显示消息发送失败，并且断开 Scoket 连接。 

还记得我们之前 CocoaAsyncSocet 的例子所讲的获取消息超时就断开吗？其实它就是一个 PingPong 机制的客户端实现。我们每次可以在发送消息成功后，调用这个超时读取的方法，如果一段时间没收到服务器的响应，那么说明连接不可用，则断开 Scoket 连接。

### 什么是重连机制

理论上，我们自己主动去断开的 Scoket 连接（例如退出账号，APP 退出到后台等等），不需要重连。其他的连接断开，我们都需要进行断线重连。一般解决方案是尝试重连几次，如果仍旧无法重连成功，那么不再进行重连。

## 开源框架

Socket 框架：
* [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket) ⭐️11.8k
* [socket.io-client-swift](https://github.com/socketio/socket.io-client-swift) ⭐️4.3k

WebSocket 框架：
* 【Archived】[SocketRocket](https://github.com/facebookarchive/SocketRocket) ⭐️9.1k
* 【Archived】[SwiftWebSocket](https://github.com/tidwall/SwiftWebSocket) ⭐️ 1.4k


## 参考

- [新手入门一篇就够：从零开发移动端 IM](http://www.52im.net/thread-464-1-1.html) ⭐️
- [Apple Doc: NWProtocolWebSocket](https://developer.apple.com/documentation/network/nwprotocolwebsocket)
- [WWDC 2019: Advances in Networking, Part 1](https://developer.apple.com/videos/play/wwdc2019/712/) - 如何在 iOS 13 中实现 Web Socket
- [微信，QQ 这类 IM app 怎么做 —— 谈谈 Websocket](https://www.jianshu.com/p/bcefda55bce4) ⭐️
- [全双工通信的 WebSocket](https://github.com/halfrost/Halfrost-Field/blob/master/contents/Protocol/WebSocket.md) ⭐️
- [SocketRocket 源码分析 @Cooci_和谐学习_不急不躁 20180816](https://www.jianshu.com/p/4cbcc024a70e) ⭐️
- [证书锁定 SSL Pinning 简介及用途 @infinisign](https://www.infinisign.com/faq/what-is-ssl-pinning)
- [IOS SSL 证书设置和锁定 (SSL/TLS Pinning) 三种方式 @infinisign](https://www.infinisign.com/faq/ios-ssl-pinning-three-method)
- [SocketRocket 的简单使用 @小李飞刀无情剑 20170909](https://www.jianshu.com/p/54fa933264c3)
- [iOS－－SocketRocket 框架的使用及测试服务器的搭建 @黑白灰的绿 20180125](https://juejin.cn/post/6844903521754546183)
- [socketRocket 封装，添加重连机制，block 回调 @gitKong 20160923](https://www.jianshu.com/p/f9917eb01180)
- [iOS-SocketRocket 长链接 简单使用 @指尖流年](https://my.oschina.net/huangyn/blog/4293967)
- [iOS 开发 - SocketRocket 使用篇 @铁头娃_e245 20190307](https://www.jianshu.com/p/0274ecaef650)
- [iOS WebSocket 长链接](http://www.yunliaoim.com/im/5366.html)
