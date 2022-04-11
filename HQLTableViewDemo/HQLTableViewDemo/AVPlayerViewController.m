//
//  AVPlayerViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2022/3/4.
//  Copyright © 2022 Qilin Hu. All rights reserved.
//

#import "AVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
 参考：<https://www.cnblogs.com/kenshincui/p/4186022.html#avPlayer>
 */

@interface AVPlayerViewController ()

@property (nonatomic, strong) AVPlayer *player; // 播放器对象

@property (weak, nonatomic) IBOutlet UIView *containerView; // 播放器容器
@property (weak, nonatomic) IBOutlet UIButton *playerButton; // 播放/暂停按钮
@property (weak, nonatomic) IBOutlet UIProgressView *progressView; // 播放进度

@end

@implementation AVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubview];

    // 给 AVPlayerItem 添加播放完成的通知，实现自动循环播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)dealloc {
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupSubview {
    // 初始化媒体资源管理对象 AVPlayerItem
    NSString *videoUrlString = @"https://haidianmall-public.oss-cn-shanghai.aliyuncs.com/hoxin-user-icon/76b6eb815b0b4693ac9244f7b3fec25dhx16463768802678.mp4";
    NSURL *videoUrl = [NSURL URLWithString:videoUrlString];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoUrl];

    // 初始化媒体播放器
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player = player;
    [self addProgressObservier];
    [self addObserverToPlayerItem:playerItem];

    // 创建播放器层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.containerView.frame;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect; // 视频填充模式
    [self.containerView.layer addSublayer:playerLayer];

    // 重置播放进度
    self.progressView.progress = 0.0;
}

// 为播放器添加播放进度更新
- (void)addProgressObservier {
    AVPlayerItem *playerItem = self.player.currentItem;
    UIProgressView *progressView = self.progressView;
    // 设置每秒执行

    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {


        float currentTime = CMTimeGetSeconds(time);
        float totalTime = CMTimeGetSeconds(playerItem.duration);
        if (currentTime) {
            NSLog(@"播放进度：%f/%f", currentTime, totalTime);
            [progressView setProgress:(currentTime/totalTime) animated:YES];
        }
    }];
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    // 监控状态属性，注意 AVPlayer 也有一个 status 属性，通过监控它的 status 也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem {
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

// 通过KVO监控播放器状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (![object isKindOfClass:[AVPlayerItem class]]) {
        return;
    }

    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = playerItem.loadedTimeRanges;
        // 本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        // 缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

#pragma mark - Notification Center

-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");

    // 播放完成后自动重播
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - Actions

- (IBAction)playButtonTapped:(UIButton *)button {
    if (self.player.rate == 0) {
        [button setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [self.player play];
    } else if (self.player.rate == 1) {
        [self.player pause];
        [button setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    }
}

@end
