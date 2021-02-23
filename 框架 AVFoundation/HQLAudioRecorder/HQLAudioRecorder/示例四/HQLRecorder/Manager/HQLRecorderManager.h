//
//  HQLRecorderManager.h
//  HQLAudioRecorder
//
//  Created by Qilin Hu on 2021/2/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HQLRecorderManagerDelegate <NSObject>

@optional

// 返回当前录音音量
- (void)recordingWithAudioPower:(float)power;

// 返回当前录音时长
- (void)recordingWithDuration:(NSTimeInterval)duration;

// 录音完成后，返回录音文件URL
- (void)recordFinishWithURL:(NSURL *_Nullable)aRecordURL error:(NSError *_Nullable)aError;

@end

@interface HQLRecorderManager : NSObject

@property (nonatomic, weak) id<HQLRecorderManagerDelegate> delegate;

/// 录音权限检查
- (BOOL)recordPermissionCheck;

/// 开始录音
- (void)startRecording;

/// 停止录音
- (void)stopRecording;

/// 销毁录音文件
- (void)destructionRecordingFile;

@end

NS_ASSUME_NONNULL_END
