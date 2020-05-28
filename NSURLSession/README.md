# The URL Loading System

The URL Loading System 描述了 **Foundation** 框架类在标准的网络传输协议下，用 URLs 连接因特网并与服务器交互的一整套体系。

## 支持的传输协议

- File Transfer Protocol (`ftp://`)
- Hypertext Transfer Protocol (`http://`)
- Hypertext Transfer Protocol with encryption (`https://`)
- Local file URLs (`file:///`)
- Data URLs (`data://`)


## 结构图

### 网络系统模块

5个模块：代理支持、身份验证和凭据、cookie 存储、配置管理和缓存管理。

Cookie，有时也用其复数形式 [Cookies](https://baike.baidu.com/item/Cookies/187064)，指某些网站为了辨别用户身份、进行 session 跟踪而储存在用户本地终端上的数据（通常经过加密）。

![](http://upload-images.jianshu.io/upload_images/2648731-051981bc3031c38f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)


## Session 会话的概念

Session中任务的行为取决于三个方面：

1. Session 的类型（取决于创建的配置对象类型）；
2. task 任务的类型；
3. task 任务被创建时，app 是否处于前台状态？

### Session 会话类型

Session 类型 | 描述 
-------------- | -------------- 
默认会话<br> (Default session) | 与其他用于下载 URL 的 Foundation 方法类似。<br> 使用永久性的基于磁盘的缓存并将凭据存储在用户的钥匙串中。
短暂会话<br> (Ephemeral session) | 不会将任何数据存储到磁盘; 所有缓存，凭证等都保存在 RAM 中并与<br>会话相关联。 因此，当应用程序使会话无效时，会自动清除该会话。
后台会话<br> (Background session) | 类似于默认会话，但是会使用单独的进程处理所有数据传输。<br> 后台会话有一些额外的限制。

注：`NSURLSession` 使用完成之后需要释放，否则会引起内存泄漏问题。

`NSURLSession` 的优势：
* `NSURLSession` 支持 HTTP 2.0 传输协议；
* 处理下载任务时，可以直接把数据下载并保存到磁盘；
* 支持后台下载和上传；
* 同一个 `session` 发送多个请求，只需要建立一次连接（复用了 TCP）；
* 提供了全局的 `session` 并且可以统一配置，使用更加方便；
* 下载的时候是多线程异步处理，效率更高；


### task 任务类型

`NSURLSession` 支持四种类型的任务：data tasks, download tasks、upload tasks 和 stream tasks。

![类的层级结构](http://upload-images.jianshu.io/upload_images/2648731-fe67c8e448c7ce34.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)

注：
* `NSURLSessionTask` 是一个抽象类，具体使用的是它的子类对象。
* `NSURLSessionDataTask` 可以用来处理一般的网络请求，如 GET、POST 等。
* `NSURLSessionUploadTask` 用于处理上传请求。
* `NSURLSessionDownloadTask` 用于处理下载请求。


任务类型 | 描述 
-------------- | -------------- 
数据任务<br>(data tasks) | 使用 `NSData` 对象发送和接收数据。处理应用程序与服务器之间的<br>简短的，经常交互的请求。 数据任务可以在每次接收到数据后就<br>返回，或者通过 completion handler 一次性返回所有数据到您的<br>应用程序。
下载任务<br>(download tasks) | 以文件的形式检索数据，并在应用程序未运行时支持后台下载。
上传任务<br>(upload tasks) | 以文件的形式发送数据，并在应用程序未运行时支持后台上传。
流任务<br>(stream tasks) | WWDC2015 新增，提供 TCP/IP 连接接口。

### NSURLSessionDelegate 委托协议

![委托协议的层级结构](http://upload-images.jianshu.io/upload_images/2648731-23944504e81ef45f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)


### 后台传输注意事项

当你的应用程序被暂停时，`NSURLSession` 也支持后台传输。 后台传输仅由使用后台会话配置的对象（调用 `backgroundSessionConfiguration :`返回的会话）提供。

* 必须提供委托对象来进行事件传递（对于上传和下载任务，代理的行为与在进程内传输相同）。
* 只支持 HTTP 和 HTTPS 协议（没有自定义协议）。
* 始终遵循重定向。
* 只支持 file 类型的文件上传（应用程序退出后，data 或 stream 类型的传输将会失败）。
* 如果在应用程序处于后台时启动后台传输，配置对象的 [discretionary](https://developer.apple.com/documentation/foundation/nsurlsessionconfiguration/1411552-discretionary) 属性将被视为 `true`。

### 网络请求创建流程
```
graph LR
NSURL-->NSURLRequest
NSURLRequest-->NSURLSessionTask
NSURLSessionConfiguration-->NSURLSession
NSURLSession-->NSURLSessionTask
```

![创建网络请求对象的流程图](http://upload-images.jianshu.io/upload_images/2648731-e9d90dd9844067b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/800)

描述：
1. 首先创建并初始化 `NSURLSessionConfiguration` 对象，进行 Session 会话配置；
2. 通过  `NSURLSessionConfiguration` 对象来创建并初始化 `NSURLSession` 对象；
3. 创建 `NSURL` 对象，即网络请求路径，通过 `NSURL` 对象创建 `NSURLRequest` 对象，创建一个请求对象；
4. 最后，基于之前创建的 `NSURLSession` 对象和 `NSURLRequest` 对象创建 `NSURLSessionTask` 对象； 

## 创建 `NSURLSessionConfiguration` 对象

`NSURLSessionConfiguration` 类的参数可以设置网络配置信息，其包含了 cookie，安全和高速缓存策略，最大主机连接数，资源管理，网络超时等配置。

创建 `NSURLSessionConfiguration` 会话配置对象有三种方式，配置类型根据你想创建的 Session 会话的类型匹配创建。

### 1. 默认会话配置

类似 `NSURLConnection` 的标准配置，用硬盘来缓存数据。

```objectivec
NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
```

### 2. 短暂会话配置

临时的进程内会话（内存），不会将 cookie、缓存（caches）和证书（credentials）储存到本地，只会放到内存中，当应用程序退出后数据也会消失，可以用于实现类似于 Safari 浏览器的 “无痕浏览模式”。

```objectivec
NSURLSessionConfiguration *ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
```

### 3. 后台会话配置

建立后台会话可以在应用程序挂起、退出、崩溃的情况下运行上传和下载任务，后台另起一个线程。另外，系统会根据设备的负载程度决定分配下载的资源，因此这种任务可能会很慢甚至超时失败。

```objectivec
NSURLSessionConfiguration *backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.Apple.BackgroundDownload.BackgroundSession"];
```

### 其他配置策略

#### `HTTPAdditionalHeaders` 设置额外的请求头

默认为空，`NSURLRequest` 附件的请求头。这个属性会给所有使用该 configuration 的 session 生成的 tasks 中的 `NSURLRequest` 添加额外的请求头。

如果这里设置的请求头跟 `NSURLRequest` 中重复了，则优先使用 `NSURLRequest` 中配置请求头。

```objectivec
configuration.HTTPAdditionalHeaders = @{
    @"Accept": @"application/json",   // 可接受的数据类型
    @"Accept-Language": @"en",
    @"Authorization": 授权信息,
    @"User-Agent": 用户代理信息
};
```

#### `networkServiceType` 指定网络传输类型

精切地指出传输类型，可以让系统快速响应，提高传输质量，延长电池寿命等。
可选的枚举类型：
```objectivec
NSURLNetworkServiceTypeDefault  // 普通网络传输，默认值
NSURLNetworkServiceTypeVoIP  // 网络语音通信传输，只能在 VoIP 使用
NSURLNetworkServiceTypeVideo  // 视频传输
NSURLNetworkServiceTypeBackground  // 后台传输，优先级不高时可使用。对用户不需要的网络操作可使用
NSURLNetworkServiceTypeVoice  // 语音传输
```


#### `allowsCellularAccess` 允许蜂窝访问

是否允许使用蜂窝网络，默认值为 `YES`。

#### `timeoutIntervalForRequest` 请求的超时时长

给 request 指定每次接收数据超时间隔，如果下一次接受新数据用时超过该值，则发送一个请求超时给该 request。默认为 60s

#### `requestCachePolicy` 缓存策略

缓存策略也可以通过 `NSURLRequest` 的 `requestWithURL:cachePolicy:timeoutInterval: ` 方法设置。无论使用哪种缓存策略，都会在本地缓存数据

`NSURLRequestCachePolicy`  是一个枚举类型：
```objectivec
 typedef NS_ENUM(NSUInteger, NSURLRequestCachePolicy)
 {
     // 默认的缓存策略，使用协议的缓存策略
     NSURLRequestUseProtocolCachePolicy = 0,
 
     // 忽略本地缓存，每次都从网络加载
     NSURLRequestReloadIgnoringLocalCacheData = 1,
    
     // 忽略本地和远程的缓存数据
     NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4,
     
     // 忽略本地缓存，每次都从网络加载
     NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,

     // 返回缓存否则加载，很少使用
     NSURLRequestReturnCacheDataElseLoad = 2,
     
     // 只返回缓存，没有也不加载，很少使用
     NSURLRequestReturnCacheDataDontLoad = 3,

     // 重新加载重新验证缓存数据
     NSURLRequestReloadRevalidatingCacheData = 5,
 };
```

详情参见：[NSURLSessionConfiguration API详解](http://blog.csdn.net/growinggiant/article/details/50483127)


## 创建和配置 Session

创建 `NSURLSession` 对象的三种方法：

### 1. 单例类会话，便捷创建方法

```objectivec
NSURLSession *sharedSession = [NSURLSession sharedSession];
```

### 2. `sessionWithConfiguration:` 方法

一般用 Completion Handle 块处理服务器返回的数据时时使用。

```objectivec
// 默认会话
NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfig];

// 短暂会话
NSURLSession *ephemeralSesson = [NSURLSession sessionWithConfiguration:ephemeralConfig];

// 后台会话
NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfig];
```


### 3.   `sessionWithConfiguration:delegate:delegateQueue:` 方法

需要遵守并实现委托协议或者指定线程的创建方法。

```objectivec
// 队列，如果该参数传递 nil 那么默认在子线程中执行
NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

// 默认会话
NSURLSession *defalutSession1 = [NSURLSession sessionWithConfiguration:defaultConfig delegate:self delegateQueue:operationQueue];

// 短暂会话
NSURLSession *ephemeralSesson1 = [NSURLSession sessionWithConfiguration:ephemeralConfig delegate:self delegateQueue:operationQueue];

// 后台会话
NSURLSession *backgroundSession1 = [NSURLSession sessionWithConfiguration:backgroundConfig delegate:self delegateQueue:operationQueue];
```

## 示例

### 一、NSURLSessionDataTask 示例

```objectivec
// MARK: 1.创建 NSURLSessionConfiguration 对象，进行 Session 会话配置
// 默认会话配置
NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

// MARK: 2.配置默认会话的缓存行为
// Caches 目录：NSCachesDirectory
NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
// 在 Caches 目录下创建创建子目录
NSString *cachePath = [cachesDirectory stringByAppendingPathComponent:@"MyCache"];
/*
 Note:
 iOS 需要设置相对路径:〜/Library/Caches
 OS X 要设置绝对路径。
 */
NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:16384
                                                  diskCapacity:268435456
                                                      diskPath:cachePath];
defaultConfig.URLCache = cache;
defaultConfig.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;

// MARK: 3.创建 NSURLSession 对象
NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfig
                                                             delegate:nil
                                                        delegateQueue:operationQueue];

// MARK: 4.创建 NSURLSessionTask
NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
NSURLSessionTask *sessionTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    // 响应对象是一个 NSHTTPURLResponse 对象实例
    NSLog(@"Got response %@ with error %@.\n", response, error);
    NSLog(@"默认会话返回数据:\n%@ \nEND DATA\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}];

// MARK: 开启任务
[sessionTask resume];
```

### 二、NSURLSessionDownloadTask 示例

```objectivec
NSURL *url = [NSURL URLWithString:@"https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/ObjC_classic/FoundationObjC.pdf"];

// 1.创建 NSURLSessionConfiguration
NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: @"com.myapp.networking.background"];

// 2.创建 NSURLSession
NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

NSURLSession *backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfiguration delegate:self delegateQueue:operationQueue];

// 3.创建 NSURLSessionDownloadTask
NSURLSessionDownloadTask *downloadTask = [backgroundSession downloadTaskWithURL:url];
[downloadTask resume];

# prama mark - Delegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"Session %@ download task %@ wrote an additional %lld bytes (total %lld bytes) out of an expected %lld bytes.\n", session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}
 
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"Session %@ download task %@ resumed at offset %lld bytes out of an expected %lld bytes.\n", session, downloadTask, fileOffset, expectedTotalBytes);
}
 
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Session %@ download task %@ finished downloading to URL %@\n", session, downloadTask, location);
 
    // Perform the completion handler for the current session
    self.completionHandlers[session.configuration.identifier]();
 
   // Open the downloaded file for reading
    NSError *readError = nil;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:location error:readError];
    // ...
 
   // Move the file to a new URL
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cacheDirectory = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    NSError *moveError = nil;
    if ([fileManager moveItemAtURL:location toURL:cacheDirectory error:moveError]) {
        // ...
    }
}
```



### 三、NSURLSessionUploadTask 示例

```objectivec
// 1.创建 NSURLSessionConfiguration
NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

// 配置默认会话的缓存行为
NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
NSString *cachePath = [cachesDirectory stringByAppendingPathComponent:@"MyCache"];

/* Note:
 iOS需要设置相对路径:〜/Library/Caches
 OS X 要设置绝对路径。
 */
NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:16384
                                                  diskCapacity:268435456
                                                      diskPath:cachePath];
defaultConfiguration.URLCache = cache;
defaultConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;

// 2.创建 NSURLSession
NSOperationQueue *operationQueue = [NSOperationQueue mainQueue];

NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:operationQueue];

// ***************************************************************
// 3.1.上传 Data 
NSURL *textFileURL = [NSURL fileURLWithPath:@"/path/to/file.txt"];
NSData *data = [NSData dataWithContentsOfURL:textFileURL];
 
NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
mutableRequest.HTTPMethod = @"POST";
[mutableRequest setValue:[NSString stringWithFormat:@"%lld", data.length] forHTTPHeaderField:@"Content-Length"];
[mutableRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
 
NSURLSessionUploadTask *uploadTask = [defaultSession uploadTaskWithRequest:mutableRequest fromData:data];
[uploadTask resume];

// ***************************************************************
// 3.2.上传 File 
NSURL *textFileURL = [NSURL fileURLWithPath:@"/path/to/file.txt"];
 
NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
mutableRequest.HTTPMethod = @"POST";
 
NSURLSessionUploadTask *uploadTask = [defaultSession uploadTaskWithRequest:mutableRequest fromFile:textFileURL];
[uploadTask resume];

// ***************************************************************
// 3.3.上传 Stream
NSURL *textFileURL = [NSURL fileURLWithPath:@"/path/to/file.txt"];
 
NSURL *url = [NSURL URLWithString:@"https://www.example.com/"];
NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
mutableRequest.HTTPMethod = @"POST";
mutableRequest.HTTPBodyStream = [NSInputStream inputStreamWithFileAtPath:textFileURL.path];
[mutableRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
[mutableRequest setValue:[NSString stringWithFormat:@"%lld", data.length] forHTTPHeaderField:@"Content-Length"];
 
NSURLSessionUploadTask *uploadTask = [defaultSession uploadTaskWithStreamedRequest:mutableRequest];
[uploadTask resume];
```

#### 使用 `NSURLSession` 上传文件主要步骤及注意点

##### 主要步骤
1. 确定上传请求的路径（ NSURL ）
2. 创建可变的请求对象（ NSMutableURLRequest ）
3. 修改请求方法为 POST
4. 设置请求头信息（告知服务器端这是一个文件上传请求）
5. 按照固定的格式拼接要上传的文件等参数
6. 根据请求对象创建会话对象（ NSURLSession 对象）
7. 根据 session 对象来创建一个 uploadTask 上传请求任务
8. 执行该上传请求任务（调用 resume 方法）
9. 得到服务器返回的数据，解析数据（上传成功 | 上传失败）

##### 注意点
1. 创建可变的请求对象，因为需要修改请求方法为 POST，设置请求头信息
2. 设置请求头这个步骤可能会被遗漏
3. 要处理上传参数的时候，一定要按照固定的格式来进行拼接
4. 需要采用合适的方法来获得上传文件的二进制数据类型（ MIMEType ）

##### MIMEType 类型

MIME (Multipurpose Internet Mail Extensions) 是描述消息内容类型的因特网标准。

MIME 消息能包含文本、图像、音频、视频以及其他应用程序专用的数据。

参考：[MIME 参考手册](https://www.w3school.com.cn/media/media_mimeref.asp)


### 四、NSURLSessionDataTask 发送 GET 请求

发送 GET 请求会使用 `NSURLSessionDataTask` 的 `dataTaskWithURL: completionHandler:` 方法。

```objectivec
// MARK: 1.封装请求路径，查询 IP 地址
// 接口来源：<https://dog.ceo/dog-api/>
NSURL *url = [NSURL URLWithString:@"https://dog.ceo/api/breeds/image/random"];

// MARK: 2.创建 NSURLSession，使用共享 Session
NSURLSession *session = [NSURLSession sharedSession];

// MARK: 3.创建 NSURLSessionDataTask, 默认 GET 请求
NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }else {
        
        // !!!: 主线程执行 UI 更新
        dispatch_async(dispatch_get_main_queue(), ^{
            // data
        });
    }
}];

// MARK: 4.执行任务
[dataTask resume];
```



### 五、NSURLSessionDataTask 发送 POST 请求

发送 POST 请求会使用 `NSURLSessionDataTask` 的 `dataTaskWithRequest: completionHandler:` 方法。

```objectivec
// 封装请求路径
NSURL *url = [NSURL URLWithString:@"https://op.juhe.cn/shanghai/hospital"];
 
// 创建请求对象
NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
// 设置请求方法
request.HTTPMethod = @"POST";
// 设置请求体
NSString *stringBody = @"dtype=&key=123";
request.HTTPBody = [stringBody dataUsingEncoding:NSUTF8StringEncoding];
 
// 1.创建 NSURLSession 对象，使用共享 Session
NSURLSession *session = [NSURLSession sharedSession];
// 2.创建 NSURLSessionDataTask
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     if (error) {
         // error
     }else {
         // 获得数据后，返回到主线程更新 UI
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             self.dataLabel.text = responseString;
         });
     }
}];
// 3.执行 Task
[dataTask resume];
```

### 六、NSURLSessionDataTask 设置代理发送请求

之前的请求获得的数据是直接在 `completionHandler:` Block 块中处理的，你也可以通过遵守 Delegate 代理的方式获得返回的数据。

```objectivec
- (void)p_NSURLSessionDataTask_Delegate {
    // 请求路径
    NSURL *url = [NSURL URLWithString:@"https://op.juhe.cn/shanghai/hospital"];
    
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方法
    request.HTTPMethod = @"POST";
    // 设置请求体
    NSString *stringBody = @"dtype=&key=5718abc3837ecb471c5d5b1ef1e35130";
    request.HTTPBody = [stringBody dataUsingEncoding:NSUTF8StringEncoding];
    
    // 1.创建 NSURLSessionConfiguration
    NSURLSessionConfiguration *configuration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
    // 2.创建 NSURLSession
    NSURLSession *session =
        [NSURLSession sessionWithConfiguration:configuration
                                      delegate:self
                                 delegateQueue:nil];
    // 3.创建 NSURLSessionDataTask
    NSURLSessionDataTask *dataTask =
        [session dataTaskWithRequest:request];
    // 4.执行 Task
    [dataTask resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    // 请求失败调用。
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    // 处理身份验证和凭据。
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    // 后台任务下载完成后调用
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    // 接收到服务器响应的时候调用
    // 默认情况下不接收数据，必须告诉系统是否接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    // 请求失败调用
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    // 接受到服务器返回数据的时候调用,可能被调用多次
}
```



### 七、获取新闻示例代码：

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //创建NSURLSession对象
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config
                                             delegate:nil
                                        delegateQueue:nil];
    //发起网络请求获取新闻
    [self fetchHrssnews];
}


#pragma mark - 获取新闻数据

- (void)fetchHrssnews {
    
    // 创建NSURLRequest对象
    NSString *requestString = @"https://example.com/api/v1/news";
    NSURL *url = [NSURL URLWithString:requestString];
    
    /**
     方法参数
     
     * 统一资源定位符：接口 URL 地址
     * 缓存策略：忽略本地缓存、
     * 等待 web 服务器响应最长时间
     */
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:60.0f];
    //设置请求方式为POST
    [req setHTTPMethod:@"POST"];
    
    //设置请求体
    NSString *dataString = @"ksym=0&jsym=15";
    NSData *postData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [req setHTTPBody:postData];
    
    //创建 NSURLSessionDataTask 对象
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //解析 JSON 数据
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:nil];
        // msgflag 是业务状态码，0 表示响应正常，1 表示响应错误。
        NSString *msgflag = jsonObject[@"msgflag"];
        // msg 是返回的具体业务数据
        __unused NSString *msg = jsonObject[@"msg"];
        
        //判断是否成功获取服务器端数据
        if ([msgflag isEqualToString:@"0"]) {
            // 返回数据成功，继续
        }else{
            // 返回数据错误，提示用户
        }
        
        // 使用 dispatch_asynch 函数让 reloadData 方法在主线程中运行
        dispatch_async(dispatch_get_main_queue(), ^{
            //重新加载UITableView对象的数据
            // [self.tableView reloadData];});
            //停止刷新
            // [self.tableView.mj_header endRefreshing];
        });
    }];
    
    // NSURLSessionDataTask 在刚创建的时候默认处于挂起状态，需要手动调用恢复。
    [dataTask resume];
}
```

## 参考

* [Apple 官方文档: URL Session Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html#//apple_ref/doc/uid/10000165i)
* 天天品尝 iOS 7 甜点_NSURLSession：[译文](http://www.voidcn.com/article/p-vqslkieb-ben.html) | [源码](https://github.com/ScottLogic/iOS7-day-by-day)
* [URLSession 详解](https://github.com/pro648/tips/wiki/URLSession%E8%AF%A6%E8%A7%A3)
* [iOS网络2——NSURLSession使用详解](http://www.cnblogs.com/mddblog/p/5215453.html)
* [iOS网络请求在Controller退出后是否应该被取消？@MrPeak](https://zhuanlan.zhihu.com/p/23204070?refer=mrpeak)
* [深度优化iOS网络模块 @MrPeak](https://zhuanlan.zhihu.com/p/22943142)
* [NSURL /NSURLComponents](http://nshipster.cn/nsurl/)
* [iOS 开发系列—网络开发](https://www.cnblogs.com/kenshincui/p/4042190.html)
