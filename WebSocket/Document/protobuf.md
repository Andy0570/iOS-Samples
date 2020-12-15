GitHub 源码：[protobuf](https://github.com/protocolbuffers/protobuf)

## 什么是 Protocol Buffers

Protocol Buffers 是 Google 开源的一种语言中立、平台无关、可扩展的序列化数据的格式，可用于通信协议，数据存储等。

Protocol buffers 在序列化数据方面是灵活而高效的。相比于 XML 来说，Protocol buffers 更加小巧、快速、简单。一旦定义了要处理的数据的数据结构之后，就可以利用 Protocol buffers 的代码生成工具生成相关的代码。甚至可以在无需重新部署程序的情况下更新数据结构。只需使用 Protobuf 对数据结构进行一次描述，即可利用各种不同语言或从各种不同数据流中对你的结构化数据轻松读写。

**Protocol buffers 很适合做数据存储或 RPC 数据交换格式。可用于通讯协议、数据存储等领域的语言无关、平台无关、可扩展的序列化结构数据格式。**

**序列化** (serialization、marshalling) 的过程是指将数据结构或者对象的状态转换成可以存储 (比如文件、内存) 或者传输的格式 (比如网络)。反向操作就是**反序列化** (deserialization、unmarshalling) 的过程。



## proto 定义

在 proto 中，所有结构化的数据都被称为 message。

```protobuf
syntax = "proto3";

message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 result_per_page = 3;
}
```

`repeated` 类型可以用来表示数组，`Map` 类型则可以用来表示字典。

```protobuf
map<key_type, value_type> map_field = N;

map<string, Project> projects = 3;
```

使用 Homebrew 安装 protobuf 编译器：

```bash
# 使用 brew 安装编译器
$ brew install protobuf

# 查看安装路径
$ which protoc
/usr/local/bin/protoc
```

在项目中集成 Protobuf：

```ruby
pod 'Protobuf', '~> 3.13.0'
```

安装 Objective-C 运行时：

```

```

使用 **protoc** 工具生成 Objective-C 代码

```bash
# 语法格式
$ protoc --proto_path=A --objc_out=B person.proto

# 创建 Person.proto 文件
$ touch Person.proto
# 将当前目录下的 Person.proto 文件生成对应的 Objective-C 代码
$ protoc --proto_path=. --objc_out=. Person.proto
```

* `protoc` 是 proto 的生成指令
* 参数的形式为：`--参数命令=参数`
* `--proto_path=.` 指出 proto 文件所在的根目录为当前目录
* `--objc_out=.` 指出生成文件所在的根目录为当前目录
* `Person.proto` 是我创建的 proto 文件



## 参考

* [Protocol Buffers](https://developers.google.com/protocol-buffers)
* [高效的数据压缩编码方式 Protobuf](https://github.com/halfrost/Halfrost-Field/blob/master/contents/Protocol/Protocol-buffers-encode.md#%E5%85%AD-protocol-buffer-%E7%BC%96%E7%A0%81%E5%8E%9F%E7%90%86)
* [高效的序列化 / 反序列化数据方式 Protobuf](https://github.com/halfrost/Halfrost-Field/blob/master/contents/Protocol/Protocol-buffers-decode.md)
* [Protobuf 终极教程](https://colobu.com/2019/10/03/protobuf-ultimate-tutorial-in-go/)
* [知乎：Protobuf 通信协议详解：代码演示、详细原理介绍等](https://zhuanlan.zhihu.com/p/141415216)
* [强列建议将 Protobuf 作为你的即时通讯应用数据传输格式](http://www.52im.net/thread-277-1-1.html)
* [Protocol Buffers（Objective-C）踩坑指南](https://juejin.cn/post/6844903902517657614)
* [iOS 网络通信之 Protobuf](https://my.oschina.net/kgdugyiy/blog/538333)
