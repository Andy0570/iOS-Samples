//
//  SecondViewController.m
//  HQLAudioRecorder
//
//  Created by Qilin Hu on 2021/2/23.
//

#import "SecondViewController.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const kRecordAudioFile = @"myRecord.caf";

@interface SecondViewController () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer; // 录音声波监控

@property (weak, nonatomic) IBOutlet UIButton *recordButton; // 开始
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;  // 暂停
@property (weak, nonatomic) IBOutlet UIButton *resumeButton; // 恢复
@property (weak, nonatomic) IBOutlet UIButton *stopButton;   // 停止

@property (weak, nonatomic) IBOutlet UIProgressView *audioPower; // 音频波动

@end

@implementation SecondViewController

#pragma mark - Initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.audioPower.progress = 0.0;
    [self setupAudioSession];
}

#pragma mark - Custom Accessors

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        // 设置音频文件保存路径
        NSURL *url = [self getSavePath];
        // 设置录音格式
        NSDictionary *recordSetting = [self getAudioSetting];
        // 创建录音器
        NSError *error = nil;
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
        if (error) {
            NSLog(@"创建录音器对象时发生错误：%@",error);
            return nil;
        }
        _recorder.delegate = self;
        // 如果要监控声波则必须设置为YES
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord]; // 为录音准备缓冲区
    }
    return _recorder;
}

- (AVAudioPlayer *)player {
    if (!_player) {
        NSURL *url = [self getSavePath];
        NSError *error = nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) {
            NSLog(@"创建播放器时发生错误：%@",error);
            return nil;
        }
        _player.numberOfLoops = 0;
        [_player prepareToPlay];
    }
    return _player;
}

// 录音声波监听定时器。进度条模拟声波状态，每0.1秒执行一次
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - Actions

// 录音按钮
- (IBAction)recordButtonTapped:(id)sender {
    if (!self.recorder.isRecording) {
        [self.recorder record];
        self.timer.fireDate = [NSDate distantPast]; // 恢复定时器
    }
}

// 暂停按钮
- (IBAction)pauseButtonTapped:(id)sender {
    if ([self.recorder isRecording]) {
        [self.recorder pause];
        self.timer.fireDate = [NSDate distantFuture]; // 暂停定时器
    }
}

// 点击恢复
// 恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
- (IBAction)resumeButtonTapped:(id)sender {
    [self recordButtonTapped:sender];
}

// 点击停止
- (IBAction)stopButtonTapped:(id)sender {
    [self.recorder stop];
    self.timer.fireDate = [NSDate distantFuture]; // 暂停定时器
    self.audioPower.progress = 0.0;
}

// 录音声波状态设置
- (void)audioPowerChange {
    [self.recorder updateMeters]; // 更新测量值
    // 取得第一个通道的音频，注意音频强度范围是-160到0
    float power = [self.recorder averagePowerForChannel:0];
    CGFloat progress = (1.0/160)*(power+160);
    [self.audioPower setProgress:progress];
}

#pragma mark - Private

// 初始化音频会话
- (void)setupAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
}

// 获取录音文件保存路径
- (NSURL *)getSavePath {
    NSString *urlString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlString = [urlString stringByAppendingPathComponent:kRecordAudioFile];
    
    return [NSURL URLWithString:urlString];
}

// 定义录音设置项
- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    // 设置录音格式
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    // 设置采样率，值需要设置为 8 kHz ～ 192 kHz
    // 8000 是电话采样率，对于一般录音已经足够了
    [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    // 设置通道，这里采用单通道
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    // 每个采样点位数,分为8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
    // 是否使用浮点数采样
    [recordSetting setValue:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsFloatKey];
    return [recordSetting copy];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"录音完成后，自动播放音频");
    if (![self.player isPlaying]) {
        [self.player play];
    }
}

@end
