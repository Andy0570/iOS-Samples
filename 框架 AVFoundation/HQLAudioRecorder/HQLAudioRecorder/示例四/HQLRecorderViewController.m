//
//  HQLRecorderViewController.m
//  HQLAudioRecorder
//
//  Created by Qilin Hu on 2021/2/23.
//

#import "HQLRecorderViewController.h"
#import "HQLRecorderManager.h"
#import "HQLRecordShowManager.h"
#import "HQLRecordButton.h"

static const CGFloat kMaxRecordDuration = 60.0f;        // 最大录音时长
static const CGFloat kRemainCountingDuration = 10.0f;   // 剩余多少秒开始倒计时

@interface HQLRecorderViewController () <HQLRecorderManagerDelegate>

@property (nonatomic, strong) HQLRecorderManager *recordManager;
@property (nonatomic, strong) HQLRecordShowManager *recordShowManager;

@property (nonatomic, strong) HQLRecordButton *recordButton;
@property (nonatomic, strong) UIButton *playerButton;

@end

@implementation HQLRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHue:192/360.0f saturation:2/100.0f brightness:95/100.0f alpha:1.0];
    
    // 播放按钮
    self.playerButton = [[UIButton alloc] initWithFrame:CGRectMake(round((self.view.frame.size.width - 150) * 0.5), 60, 150, 80)];
    [self.playerButton addTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.playerButton setTitle:@"点击我 播放语音" forState:UIControlStateNormal];
    self.playerButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.playerButton];
    
    // 录音按钮
    self.recordButton = [HQLRecordButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake(20, self.view.frame.size.height - 150, self.view.frame.size.width - 40, 40);
    self.recordButton.backgroundColor = [UIColor whiteColor];
    self.recordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.recordButton.layer.cornerRadius = 4;
    self.recordButton.clipsToBounds = YES;
    [self.recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.recordButton];
    
    self.recordShowManager = [[HQLRecordShowManager alloc] init];
    
    self.recordManager = [[HQLRecorderManager alloc] init];
    self.recordManager.delegate = self;
    [self initializeRecordButton];
}

- (void)initializeRecordButton {
    __weak __typeof(self)weakSelf = self;
    
    // 手指按下
    self.recordButton.touchDownAction = ^(HQLRecordButton * _Nonnull recordButton) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        // 如果用户没有开启麦克风权限，不能让其录音
        if (![strongSelf.recordManager recordPermissionCheck]) { return; }
        
        NSLog(@"开始录音");
        [recordButton setButtonStateWithRecording];
        [strongSelf.recordManager startRecording];
        strongSelf.recordShowManager.recordState = HQLRecordStateRecording;
    };
    
    // 手指抬起
    self.recordButton.touchUpInsideAction = ^(HQLRecordButton * _Nonnull recordButton) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSLog(@"完成录音");
        [recordButton setButtonStateWithNormal];
        [strongSelf.recordManager stopRecording];
        strongSelf.recordShowManager.recordState = HQLRecordStateNormal;
    };
    
    // 手指滑出按钮
    self.recordButton.touchUpOutsideAction = ^(HQLRecordButton * _Nonnull recordButton) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSLog(@"取消录音");
        [recordButton setButtonStateWithNormal];
        [strongSelf.recordManager destructionRecordingFile];
        strongSelf.recordShowManager.recordState = HQLRecordStateNormal;
    };
    
    // 中间状态，从 TouchDragInside ---> TouchDragOutside
    self.recordButton.touchDragExitAction = ^(HQLRecordButton * _Nonnull recordButton) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSLog(@"中间状态，从 TouchDragInside ---> TouchDragOutside");
        strongSelf.recordShowManager.recordState = HQLRecordStateReleaseToCancel;
    };
    
    //中间状态  从 TouchDragOutside ---> TouchDragInside
    self.recordButton.touchDragEnterAction = ^(HQLRecordButton * _Nonnull recordButton) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSLog(@"中间状态  从 TouchDragOutside ---> TouchDragInside");
        strongSelf.recordShowManager.recordState = HQLRecordStateRecording;
    };
}

#pragma mark - Actions

- (void)playVoice {
    
}

#pragma mark - HQLRecorderManagerDelegate

// 返回当前录音音量
- (void)recordingWithAudioPower:(float)power {
    if (self.recordShowManager.recordState == HQLRecordStateRecording) {
        [self.recordShowManager updatePower:power];
    }
}

// 返回当前录音时长
- (void)recordingWithDuration:(NSTimeInterval)duration {
    NSLog(@"duration === %f",duration);
    
    if (duration >= (kMaxRecordDuration - kRemainCountingDuration) && duration < kMaxRecordDuration && self.recordShowManager.recordState != HQLRecordStateReleaseToCancel) {
        
        // 倒计时状态
        self.recordShowManager.recordState = HQLRecordStateRecordCounting;
        [self.recordShowManager updateRemainTime:kMaxRecordDuration - duration];
    }
}

// 录音完成后，返回录音文件URL
- (void)recordFinishWithURL:(NSURL *_Nullable)aRecordURL error:(NSError *_Nullable)aError {
    NSLog(@"录音完成后，返回录音文件URL:\n%@",aRecordURL.path);
    NSLog(@"录音失败:\n%@",aError);
}

@end
