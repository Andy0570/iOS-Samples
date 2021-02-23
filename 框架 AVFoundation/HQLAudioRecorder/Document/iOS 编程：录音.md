## 介绍

`AVFoundation` 中，使用 `AVAudioPlayer` 实现音频播放功能是非常简单的。同样，使用 `AVAudioRecorder` 实现音频录制功能也是非常简单的。`AVAudioRecorder` 同其用于播放音频一样，构建于 `Audio Queue Services` 之上，是一个功能强大且代码简单易用的 `Objective-C` 接口。我们可以在 `Mac` 机器和 `iOS` 设备上使用这个类来从内置的麦克风录制音频，也可从外部音频设备进行录制，比如数字音频接口或 USB 麦克风等。



## AVAudioRecorder

`AVAudioRecorder` 支持多种音频格式。与 `AVAudioPlayer` 类似，你完全可以将它看成是一个录音机控制类，下面是常用的属性和方法：



### 属性

```objective-c
// 是否正在录音，只读
@property (readonly, getter=isRecording) BOOL recording;

// 录音配置，只读
@property (readonly) NSDictionary<NSString *, id> *settings;

// 录音文件存放 URL，只读
@property (readonly) NSURL *url;

// 录音时长，只读，注意仅仅在录音状态可用
@property (readonly) NSTimeInterval currentTime;

// 获取设备当前时间，只读，注意此属性一直可访问
@property(readonly) NSTimeInterval deviceCurrentTime;

// 是否启用录音测量，如果启用录音测量可以获得录音分贝等数据信息
@property (getter=isMeteringEnabled) BOOL meteringEnabled;
```



### 方法

```objective-c
// 录音机对象初始化方法，注意其中的 url 必须是本地文件 url，settings 是录音格式、编码等设置
- (instancetype)initWithURL:(NSURL *)url settings:(NSDictionary *)settings error:(NSError **)outError

// 准备录音，主要用于创建缓冲区，如果不手动调用，在调用 record 录音时也会自动调用
- (BOOL)prepareToRecord;

// 录音开始，暂停后调用此方法会恢复录音
- (BOOL)record;

// 在指定时间后开始录音，一般用于录音暂停再恢复录音
- (BOOL)recordAtTime:(NSTimeInterval)time;

// 按指定的时长开始录音
- (BOOL)recordForDuration:(NSTimeInterval) duration;

// 在指定的时间开始录音，并指定录音时长
- (BOOL)recordAtTime:(NSTimeInterval)time 
         forDuration:(NSTimeInterval)duration;

// 暂停录音
- (void)pause;

// 停止录音
- (void)stop;

// 删除录音，必须先停止录音再删除
- (BOOL)deleteRecording;

// 更新测量数据，注意只有设置 meteringEnabled 属性为 YES 此方法才可用
- (void)updateMeters;

// 指定通道的测量峰值，注意只有调用完 updateMeters 才有值
- (float)peakPowerForChannel:(NSUInteger)channelNumber;

// 指定通道的测量平均值，注意只有调用完 updateMeters 才有值
- (float)averagePowerForChannel:(NSUInteger)channelNumber
```



### 代理方法



```objective-c
//录音完成后调用
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder 
                           successfully:(BOOL)flag;
//录音编码发送错误时调用
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder 
                                   error:(NSError *)error;
```



`AVAudioRecorder` 很多属性和方法跟 `AVAudioPlayer` 都是类似的，但是它的创建有所不同，在创建录音机时除了指定路径外还必须指定录音设置信息，因为录音机必须知道录音文件的格式、采样率、通道数、每个采样点的位数等信息，但是也并不是所有的信息都必须设置，通常只需要几个常用设置。





### 录音器音频队列服务的工作原理

![](https://upload-images.jianshu.io/upload_images/1795722-224996f89679bc19.png?imageMogr2/auto-orient/strip|imageView2/2/w/650/format/webp)



### 播放器音频队列服务的工作原理

![](https://upload-images.jianshu.io/upload_images/1795722-45f6a868779059d0.png?imageMogr2/auto-orient/strip|imageView2/2/w/717/format/webp)





## 参考

* [iOS 多媒体－录音](http://billchan.me/2017/03/26/ios-media-avaudiorecorder/)
* [iOS 学习笔记 25 - 录音和网络流媒体](https://www.jianshu.com/p/4bcb3d3a1b14)





---

## StreamingKit 框架

GitHub:<https://github.com/tumtumtum/StreamingKit>



StreamingKit（正式名称为Audjustable）是一个适用于 iOS 和 Mac OSX 的音频播放和流媒体库。StreamingKit 使用 CoreAudio 来解压和播放音频（使用硬件或软件编解码器），同时提供了一个干净和简单的面向对象的 API。

这个项目的主要动机是将输入数据源与实际的播放器逻辑解耦，以允许高级的可定制的输入处理，如基于 HTTP 的渐进式下载流，加密/解密，自动恢复，动态缓冲。StreamingKit 是唯一一个支持不同格式的音频文件之间无间隙播放的流媒体和播放库。





## 主要功能

免费开放源码软件。
简单的API。
易于阅读的源代码。
仔细的多线程提供了一个响应式的API，它既不会阻塞你的UI线程，也不会饿死音频缓冲区。
所有格式类型之间的缓冲和无间隙播放。
易于实现音频数据源（提供本地、HTTP、AutoRecoveringHTTP数据源）。
易于扩展DataSource，以支持自适应缓冲、加密等功能。
针对低CPU/电池使用率进行了优化（流媒体时CPU使用率为0%-1%）。
针对线性数据源进行了优化。随机访问源只需要寻找。
StreamingKit 0.2.0使用了AudioUnit API，而不是较慢的AudioQueues API，它允许实时截取原始PCM数据，以实现诸如电平测量、EQ等功能。
功率计量
内置均衡器/EQ（iOS 5.0及以上，OSX 10.9 Mavericks及以上），支持在播放时动态更改/启用/禁用EQ。
提供iOS和Mac OSX的应用实例。



## 示例

主要有两个类。`STKDataSource` 类，它是各种压缩音频数据源的抽象基类。`STKAudioPlayer` 类管理和渲染来自队列DataSources 的音频。默认情况下，`STKAudioPlayer` 会自动解析URL并在内部创建相应的数据源。



## 播放基于 HTTP 的 MP3

```objc
STKAudioPlayer* audioPlayer = [[STKAudioPlayer alloc] init];

[audioPlayer play:@"http://www.abstractpath.com/files/audiosamples/sample.mp3"];
```



## 无缝播放

```objc
STKAudioPlayer* audioPlayer = [[STKAudioPlayer alloc] init];

[audioPlayer queue:@"http://www.abstractpath.com/files/audiosamples/sample.mp3"];
[audioPlayer queue:@"http://www.abstractpath.com/files/audiosamples/airplane.aac"];
```





## 在PCM数据播放前截获它

```objc
[audioPlayer appendFrameFilterWithName:@"MyCustomFilter" block:^(UInt32 channelsPerFrame, UInt32 bytesPerFrame, UInt32 frameCount, void* frames)
{
   ...
}];
```



