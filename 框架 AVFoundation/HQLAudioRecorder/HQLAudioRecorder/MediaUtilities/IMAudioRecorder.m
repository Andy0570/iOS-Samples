//
//  IMAudioRecorder.m
//  IMKit
//
//  Created by Qilin Hu on 2021/2/25.
//

#import "IMAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

static IMAudioRecorder *_sharedInstance = nil;
static NSString * const kRecordAudioFileName = @"myRecord.m4a";

@interface IMAudioRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) IMAudioRecordVolumedChangedBlock volumedChangedBlock;
@property (nonatomic, copy) IMAudioRecordCompletionBlock completionBlock;
@property (nonatomic, copy) IMAudioRecordCancelBlock cancelBlock;

@end

@implementation IMAudioRecorder

+ (IMAudioRecorder *)sharedAudioRecorder {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Custom Accessors

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        // 创建录音会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if (!session) {
            DDLogError(@"创建录音会话错误：%@",sessionError);
            return nil;
        } else {
            [session setActive:YES error:nil];
        }
        
        // 设置音频文件
        NSURL *recordFileURL = [self getRecordFileURL];
        
        // 定义录音设置项
        NSDictionary *recordSetting = [self getAudioSetting];
        
        // 创建录音器
        NSError *recordError = nil;
        _recorder = [[AVAudioRecorder alloc] initWithURL:recordFileURL settings:recordSetting error:&recordError];
        if (!_recorder) {
            DDLogError(@"创建录音会话错误：%@",recordError);
            return nil;
        }
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
    }
    return _recorder;
}

#pragma mark - Public

- (void)startRecordingWithVolumeChangedBlock:(IMAudioRecordVolumedChangedBlock)aVolumedChangedBlock
                             completionBlock:(IMAudioRecordCompletionBlock)aCompletionBlock
                                 cancleBlock:(IMAudioRecordCancelBlock)aCancleBlock
{
    self.volumedChangedBlock = aVolumedChangedBlock;
    self.completionBlock = aCompletionBlock;
    self.cancelBlock = aCancleBlock;
    
    NSString *recordFilePath = [self getRecordFileURL].path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:recordFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:recordFilePath error:nil];
    }
    [self.recorder prepareToRecord];
    [self.recorder record];
    
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
    }
    __weak __typeof(self)weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 block:^(NSTimer * _Nonnull timer) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.recorder updateMeters];
        float peakPower = pow(10, (0.05 * [strongSelf.recorder peakPowerForChannel:0]));
        if (strongSelf.volumedChangedBlock) {
            strongSelf.volumedChangedBlock(peakPower);
        }
    } repeats:YES];
}

- (void)stopRecording {
    [self.timer invalidate];
    [self.recorder stop];
}

- (void)cancelRecording {
    [self.timer invalidate];
    [self.recorder stop];
    if (self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}

#pragma mark - Private

// 设置录音文件保存路径
- (NSURL *)getRecordFileURL {
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *recordFileURL = [documentsURL URLByAppendingPathComponent:kRecordAudioFileName];
    return recordFileURL;
}

// 定义录音设置项
- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    // 设置音频格式
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    // 设置采样率，值需要设置为 8 kHz ～ 192 kHz
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    // 设置通道，这里采用单通道
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    // 线性音频的位深度,分为8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
    // 录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    return [recordSetting copy];
}

#pragma mark - AVAudioRecorderDelegate

// 录音完成后，返回录音文件URL
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag && self.completionBlock) {
        DDLogDebug(@"录音成功");
        CGFloat time = self.recorder.currentTime;
        self.completionBlock([self getRecordFileURL].path, time);
        self.completionBlock = nil;
    }
}

// 录音失败，返回错误
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    if (self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}

@end
