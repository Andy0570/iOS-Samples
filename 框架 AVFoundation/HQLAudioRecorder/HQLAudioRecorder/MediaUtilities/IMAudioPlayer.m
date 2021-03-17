//
//  IMAudioPlayer.m
//  IMKit
//
//  Created by Qilin Hu on 2021/2/25.
//

#import "IMAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

static IMAudioPlayer *_sharedInstance = nil;

@interface IMAudioPlayer() <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) IMAudioPlayCompletionBlock completionBlock;

@end

@implementation IMAudioPlayer

+ (IMAudioPlayer *)sharedAudioPlayer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)playAudioAtPath:(NSString *)path completion:(IMAudioPlayCompletionBlock)aCompletionBlock {
    if (self.player && self.player.isPlaying) {
        [self stopPlayingAudio];
    }
    
    self.completionBlock = aCompletionBlock;
    NSError *error;
    NSURL *audioURL = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    self.player.delegate = self;
    if (error) {
        if (self.completionBlock) {
            self.completionBlock(NO);
            self.completionBlock = nil;
        }
        return;
    }
    [self.player play];
}

- (void)stopPlayingAudio {
    [self.player stop];
    if (self.completionBlock) {
        self.completionBlock(NO);
        self.completionBlock = nil;
    }
}

- (BOOL)isPlaying {
    if (self.player) {
        return self.player.isPlaying;
    }
    return NO;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.completionBlock) {
        self.completionBlock(YES);
        self.completionBlock = nil;
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    DDLogError(@"音频播放出现错误：%@", error);
    if (self.completionBlock) {
        self.completionBlock(NO);
        self.completionBlock = nil;
    }
}

@end
