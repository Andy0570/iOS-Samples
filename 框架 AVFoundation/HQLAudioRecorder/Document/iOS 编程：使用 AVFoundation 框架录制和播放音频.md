# iOS 编程：使用 AVFoundation 框架录制和播放音频

> 原文：[iOS Programming 101: Record and Play Audio using AVFoundation Framework](https://www.appcoda.com/ios-avfoundation-framework-tutorial/)



编者按：有网友要求我们写一篇关于录音的教程。本周，我们与 [Purple Development](http://www.purpledevelopment.net/) 的 Shi Yiqi 和 Raymond 一起给大家介绍 AVFoundation 框架。Yiqi 和 Raymond 是独立的 iOS 开发者，最近他们发布了 [Voice Memo Wifi](https://itunes.apple.com/us/app/voice-memo-wifi-sharing-lite/id590371641?mt=8)，可以让用户录制语音备忘录并通过 WiFi 分享。



iOS 提供了各种框架让你在应用程序中使用声音。其中有一个可以让你播放和录制音频文件的框架叫做 AVFoundation。在本教程中，我将带领你了解该框架的基础知识，并向你展示如何管理音频播放，以及录音。



为了给大家提供一个实例，我将构建一个简单的音频应用，让用户可以录制和播放音频。我们的主要目的是演示 AVFoundation 框架，所以应用的用户界面非常简单。



AVFoundation 提供了处理音频的简单方法。在本教程中，我们主要处理这两个类。

* AVAudioPlayer —— 把它看作是一个可以播放声音文件的音频播放器。通过使用该播放器，你可以播放任何时间长度和（在 iOS 中可用的）任何音频格式的声音。
* AVAudioRecorder —— 一个用于录制音频的音频记录器。



## 从示例项目开始

首先，创建一个 "Single View Application" 模版的项目，并命名为 "AudioDemo"。为了让你免于设置用户界面和代码框架，你可以从这里[下载项目模板](https://dl.dropbox.com/u/2857188/AudioDemo_Start.zip)。

我为你创建了一个简单的用户界面，它只包含三个按钮，包括 "Record"、"Stop"和 "Play"。这些按钮也是用代码链接起来的。

![](https://www.appcoda.com/wp-content/uploads/2013/02/AudioDemo-Project-Template.jpg)



## 添加 AVFoundation 框架

默认情况下，AVFoundation 框架没有捆绑在任何 Xcode 项目中。所以你必须手动添加它。在项目导航栏中，选择 "AudioDemo" 项目，接着选择 TARGETS 下的 "AudioDemo"，然后点击 "Build Phases"。展开 "Link Binary with Libraries"，点击 "+"按钮，添加 "AVFoundation.framework"。

![](https://www.appcoda.com/wp-content/uploads/2013/02/Adding-AVFoundation-Framework.jpg)



要使用 `AVAudioPlayer` 和 AVAudioRecorder 这两个类，我们需要在 `ViewController.h` 中导入：

```objective-c
#import <AVFoundation/AVFoundation.h>
```



## 使用 AVAudioRecorder 录制音频

首先，我们来看看如何使用 `AVAudioRecorder` 来录制音频。在 `ViewController.h` 中添加 `AVAudioRecorderDelegate` 协议和 `AVAudioPlayerDelegate` 协议。我们将在讲解代码的时候对这两个委托进行解释。

```objc
@interface ViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
```

接下来，在 `ViewController.m` 中声明 `AVAudioRecorder` 和 `AVAudioPlayer` 的实例变量。

```objective-c
@interface ViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

@end
```

`AVAudioRecorder` 类提供了一种在 iOS 中录制声音的简单方法。要使用录音机，你必须准备一些东西：

* 指定存放声音文件的 URL 路径。
* 设置音频会话（`AVAudioSession`）。
* 配置 audio recorder 的初始状态。



我们将在 `ViewController.m` 的 `viewDidLoad`  方法中进行设置，只需要在该方法中编辑以下代码即可：

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 当应用启动时，禁用 Stop/Play 按钮
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:NO];
    
    // 设置音频文件
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"MyAudioMemo.m4a",nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];

    // 设置音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // 定义录音设置项
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    // 初始化录音器并设置为准备状态
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}
```

注：为了演示的目的，我们忽略了错误处理。在实际应用中，不要忘记包含适当的错误处理。

在上面的代码中，我们首先定义了用于保存录音的声音文件URL。然后配置音频会话（audio session）。iOS 通过使用音频会话来处理应用程序的音频行为。在启动时，你的应用会自动获得一个音频会话。你可以通过调用 `[AVAudioSession sharedInstance]` 来获得会话单例，并对其进行配置。在这里，我们告诉 iOS，应用程序使用 `AVAudioSessionCategoryPlayAndRecord` 类别，可以实现音频输入和输出。关于音频会话的细节我们就不多说了，大家可以查看[官方文档](https://developer.apple.com/documentation/avfaudio/avaudiosession?language=objc)了解更多细节。

`AVAudioRecorder` 使用基于字典的设置进行配置。在第21-25行，我们使用可选的键来配置音频数据格式、采样率和通道数。最后，我们通过调用 `prepareToRecord:` 方法来启动音频记录器。

注：关于其他设置键，可以参考 [AVFoundation 音频设置常量](https://developer.apple.com/documentation/avfaudio/avaudiorecorder/1388386-initwithurl?language=objc)。



## 实现录音按钮

我们已经完成了音频的准备工作。让我们继续实现 "Record" 按钮的动作方法。在进入代码之前，我先解释一下 "Record" 按钮的工作原理。当用户点击 "Record" 按钮时，应用程序将开始录制，按钮文字将改为 "Pause"。如果用户点击暂停按钮，应用程序将暂停录音，直到再次点击 "Record" 按钮。只有当用户点击 "Stop" 按钮时，录音才会停止。

在 `recordButtonTapped:` 方法中编辑以下代码：

```objective-c
// 录制/暂停按钮
- (IBAction)recordButtonTapped:(id)sender {
    // 在录制前停止音频播放
    if (self.player.isPlaying) {
        [self.player stop];
    }
    
    if (!self.recorder.isRecording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // 开始录音
        [self.recorder record];
        [self.recordButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        
        // 停止录音
        [self.recorder pause];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [self.stopButton setEnabled:YES];
    [self.playButton setEnabled:NO];
}
```

在上面的代码中，我们首先检查音频播放器是否正在播放中。如果音频播放器正在播放，我们只需使用 `stop:` 方法停止它。上述代码的第 7 行确定应用程序是否处于录音模式。如果不在录音模式下，应用程序就会激活音频会话并开始录音。为了让录音工作（或声音播放），你的音频会话必须处于激活（active）状态。

通常来说，你可以使用 `AVAudioRecorder` 类的以下方法来控制录音行为：

* `record` - 开始/恢复录音
* `pause` - 暂停录音
* `stop` - 停止录音



## 实现停止按钮

对于 "Stop" 按钮，我们只需调用录音器的 `stop:` 方法，然后停用音频会话。在 `stopButtonTapped:` 方法中编辑添加以下代码。

```objective-c
// 停止按钮
- (IBAction)stopButtonTapped:(id)sender {
    [self.recorder stop];
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
}
```


## 实现 AVAudioRecorderDelegate 协议

你可以利用 `AVAudioRecorderDelegate` 协议来处理音频中断（比如说，音频录制过程中有一个来电电话）和录制的完成。在本例中，ViewController 遵守此协议。`AVAudioRecorderDelegate` 协议中定义的方法是可选的。这里，我们只实现 `audioRecorderDidFinishRecording:` 方法来处理录音的完成。在 `ViewController.m` 中添加以下代码。

```objective-c
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
}
```

完成录制后，我们只需将 "Pause" 按钮改回 "Record" 按钮即可。



## 使用 AVAudioPlayer 播放声音

最后，就到了使用 `AVAudioPlayer` 实现音频播放的 "Play" 按钮了。在 `ViewController.m`中，在 `playButtonTapped:` 方法中编辑添加以下代码：

```objective-c
// 播放按钮
- (IBAction)playButtonTapped:(id)sender {
    if (!self.recorder.isRecording) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        self.player.delegate = self;
        [self.player play];
    }
}
```

上面的代码非常简单。通常情况下，配置一个音频播放器要做这几件事：

* 初始化音频播放并指定一个声音文件给它。在本例中，是录音器的音频文件（即 `recorder.url`）。
* 指定音频播放器的委托对象，它处理中断以及播放完成事件。
* 调用 `play:` 方法来播放声音文件。



## 实现 AVAudioPlayerDelegate 协议

`AVAudioPlayer` 对象的委托必须遵守 `AVAudioPlayerDelegate` 协议。在本例中，它是 ViewController。委托者允许你处理中断、音频解码错误，并在音频播放完毕后更新用户界面。然而，`AVAudioPlayerDelegate` 协议中的所有方法都是可选的。为了演示它是如何工作的，我们将实现 `audioPlayerDidFinishPlaying:` 方法来在音频播放完成后显示一个警报提示。其他方法的用法，可以参考`AUAudioPlayerDelegate` 协议的官方文档。

在 `ViewController.m` 中添加以下代码：

```objective-c
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //  1.实例化UIAlertController对象
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Done" message:@"Finish playing the recording!" preferredStyle:UIAlertControllerStyleAlert];

    //  2.实例化UIAlertAction按钮:确定按钮
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];

    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
}
```



## 编译并运行应用

你可以使用实际设备或软件模拟器测试音频录制和播放。如果你使用实际设备（如iPhone）测试应用程序，则录制的音频来自于通过内置麦克风或耳机麦克风连接的设备。另外，如果你使用模拟器测试应用程序，音频来自系统偏好设置中的默认音频输入设备。

注：访问麦克风需要访问并获取隐私权限，因此，请在项目的  `Info.plist` 文件中设置 `Privacy - Microphone Usage Description` 项。

所以请继续编译并运行该应用吧! 点 "Record" 按钮，开始录制。说点什么，点 "Stop" 按钮，然后选择 "Play" 按钮，收听播放。

![](https://www.appcoda.com/wp-content/uploads/2013/02/AudioDemo-App.jpg)

大家可以从[这里](https://dl.dropbox.com/u/2857188/AudioDemo.zip)下载完整的源码，供大家参考。如果你有什么问题，欢迎给我留言。

本篇文章由来自 Purple Development 的 Yiqi Shi 和 Raymond 贡献。Yiqi 和 Raymond 是独立的 iOS 开发者，最近他们发布了 Voice Memo Wifi，可以让用户录制语音备忘录并通过 WiFi 分享。



## 附：完整源码

```objective-c
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 当应用启动时，禁用 Stop/Play 按钮
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:NO];
    
    // 设置音频文件
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"MyAudioMemo.m4a",nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];

    // 设置音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // 定义录音设置项
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    // 初始化录音器并设置为准备状态
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

#pragma mark - Actions

// 录制/暂停按钮
- (IBAction)recordButtonTapped:(id)sender {
    // 在录制前停止音频播放
    if (self.player.isPlaying) {
        [self.player stop];
    }
    
    if (!self.recorder.isRecording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // 开始录音
        [self.recorder record];
        [self.recordButton setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        
        // 停止录音
        [self.recorder pause];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [self.stopButton setEnabled:YES];
    [self.playButton setEnabled:NO];
}

// 停止按钮
- (IBAction)stopButtonTapped:(id)sender {
    [self.recorder stop];
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
}

// 播放按钮
- (IBAction)playButtonTapped:(id)sender {
    if (!self.recorder.isRecording) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        self.player.delegate = self;
        [self.player play];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //  1.实例化UIAlertController对象
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Done" message:@"Finish playing the recording!" preferredStyle:UIAlertControllerStyleAlert];

    //  2.实例化UIAlertAction按钮:确定按钮
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];

    //  3.显示alertController
    [self presentViewController:alert animated:YES completion:nil];
}

@end
```

