> 原文：<https://github.com/robbiehanson/CocoaAsyncSocket/wiki/GeneralDocumentation>

如果你是一个网络初学者，你可以从阅读[简介](https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Intro)开始

## TCP

有两个单独的库可用于 TCP: **GCDAsyncSocket** 和 **AsyncSocket**。

AsyncSocket 是两个库中较老的一个。GCDAsyncSocket 是较新、较快且线程安全的库。我们一般推荐使用 GCDAsyncSocket。

它们的 API 非常相似。事实上，GCDAsyncSocket 几乎可以直接替代 AsyncSocket。

* [Intro_GCDAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Intro_GCDAsyncSocket)
* [Reference_GCDAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Reference_GCDAsyncSocket)
* [Reference_AsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket/wiki/Reference_AsyncSocket)

## UDP

有两个单独的库可用于UDP: **GCDAsyncUdpSocket** 和 AsyncUdpSocket。

AsyncUdpSocket 是两个库中较老的一个。GCDAsyncUdpSocket 是较新、较快和线程安全的库。我们一般推荐使用 GCDAsyncUdpSocket。