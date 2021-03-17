//
//  IMAudioPlayer.h
//  IMKit
//
//  Created by Qilin Hu on 2021/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^IMAudioPlayCompletionBlock)(BOOL finished);

@interface IMAudioPlayer : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;

+ (IMAudioPlayer *)sharedAudioPlayer;

- (void)playAudioAtPath:(NSString *)path completion:(IMAudioPlayCompletionBlock)aCompletionBlock;

- (void)stopPlayingAudio;

@end

NS_ASSUME_NONNULL_END
