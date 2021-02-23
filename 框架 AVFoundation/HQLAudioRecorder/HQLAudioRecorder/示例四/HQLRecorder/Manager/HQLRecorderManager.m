//
//  HQLRecorderManager.m
//  HQLAudioRecorder
//
//  Created by Qilin Hu on 2021/2/23.
//

#import "HQLRecorderManager.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const kRecordErrorDomain = @"com.CustomError.RecordManager";
static NSString * const kRecordAudioFileName = @"myRecord.m4a";
static const CGFloat KTimeDuration = 1.0f;
static const CGFloat KMaxRecordDuration = 60.0f;       // 最大录音时长
static const CGFloat KRemainCountingDuration = 10.0f;  // 剩余多少秒开始倒计时

typedef struct {
    unsigned int respondsToAudioPowerDelegate : 1;
    unsigned int respondsToRecordDurationDelegate : 1;
    unsigned int respondsToRecordFinishDelegate : 1;
} DelegateFlags;

@interface HQLRecorderManager () <AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *timer; // 录音声波监控
@property (nonatomic, assign) DelegateFlags delegateFlag;
@end

@implementation HQLRecorderManager

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    return self;
}

#pragma mark - Custom Accessors

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        // 设置音频文件
        NSURL *recordFileURL = [self getRecordFileURL];
        // 定义录音设置项
        NSDictionary *recordSetting = [self getAudioSetting];
        // 创建录音器
        NSError *error = nil;
        _recorder = [[AVAudioRecorder alloc] initWithURL:recordFileURL settings:recordSetting error:&error];
        if (error) {
            if (_delegateFlag.respondsToRecordFinishDelegate) {
                [_delegate recordFinishWithURL:nil error:error];
            }
            return nil;
        }
        _recorder.delegate = self;
        // 如果要监控声波则必须设置为YES
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord]; // 为录音准备缓冲区
    }
    return _recorder;
}

// 录音声波监听定时器。进度条模拟声波状态，每1秒执行一次
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:KTimeDuration target:self selector:@selector(updateRecordingState) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)setDelegate:(id<HQLRecorderManagerDelegate>)delegate {
    _delegate = delegate;
    
    // 提前缓存方法的响应能力
    _delegateFlag.respondsToAudioPowerDelegate = [delegate respondsToSelector:@selector(recordingWithAudioPower:)];
    _delegateFlag.respondsToRecordDurationDelegate = [delegate respondsToSelector:@selector(recordingWithDuration:)];
    _delegateFlag.respondsToRecordFinishDelegate = [delegate respondsToSelector:@selector(recordFinishWithURL:error:)];
}

#pragma mark - Actions

- (void)updateRecordingState {
    if (!self.recorder.isRecording) { return; }
    
    // 返回当前录音音量
    [self audioPowerChange];
    
    // 返回当前录音时间
    if (_delegateFlag.respondsToRecordDurationDelegate) {
        [_delegate recordingWithDuration:self.recorder.currentTime];
    }
}

// 录音声波状态设置
- (void)audioPowerChange {
    [self.recorder updateMeters]; // 更新测量值
    //  指定通道的测量峰值，注意音频强度范围是-160到0
    float decibels = [self.recorder peakPowerForChannel:0];
    float level = 0.0f; // The linear 0.0 .. 1.0 value we need.
    float minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    
    if (decibels < minDecibels) {
        level = 0.0f;
    } else if (decibels >= 0.0f) {
        level = 1.0f;
    } else {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        level = powf(adjAmp, 1.0f / root);
    }

    // 通过代理返回声波值
    if (_delegateFlag.respondsToAudioPowerDelegate) {
        [_delegate recordingWithAudioPower:level];
    }
}

#pragma mark - Public

/// 录音权限检查
- (BOOL)recordPermissionCheck {
    __block BOOL canRecord = NO;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            canRecord = granted;
        }];
    }
    return canRecord;
}

/// 开始录音
- (void)startRecording {
    [self destructionRecordingFile];
    
    if (!self.recorder.isRecording) {
        // 初始化音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryRecord error:nil];
        [session setActive:YES error:nil];
        
        [self.recorder recordForDuration:KMaxRecordDuration];
        self.timer.fireDate = [NSDate distantPast]; // 恢复定时器
    }
}

/// 停止录音
- (void)stopRecording {
    if (self.recorder.isRecording) {
        [self.recorder stop];
        self.timer.fireDate = [NSDate distantFuture]; // 暂停定时器
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
    }
}

- (void)pauseRecording {
    if (self.recorder.isRecording) {
        [self.recorder pause];
        self.timer.fireDate = [NSDate distantFuture]; // 暂停定时器
    }
}

/// 销毁录音文件
- (void)destructionRecordingFile {
    [self pauseRecording];
    [self.recorder deleteRecording];
}

#pragma mark - Private

// 设置录音文件保存路径
- (NSURL *)getRecordFileURL {
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *recordFileURL = [documentsURL URLByAppendingPathComponent:kRecordAudioFileName];
    return recordFileURL;
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

// 录音完成后，返回录音文件URL
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    NSLog(@"%@",flag? @"YES": @"NO");
    
    if (_delegateFlag.respondsToRecordFinishDelegate) {
        [_delegate recordFinishWithURL:recorder.url error:nil];
    }
}

// 录音失败，返回错误
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    if (_delegateFlag.respondsToRecordFinishDelegate) {
        [_delegate recordFinishWithURL:nil error:error];
    }
}

@end
