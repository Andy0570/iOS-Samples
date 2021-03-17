//
//  IMAudioRecorder.h
//  IMKit
//
//  Created by Qilin Hu on 2021/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^IMAudioRecordVolumedChangedBlock)(CGFloat volume);
typedef void(^IMAudioRecordCompletionBlock)(NSString *path, CGFloat time);
typedef void(^IMAudioRecordCancelBlock)(void);

@interface IMAudioRecorder : NSObject

+ (IMAudioRecorder *)sharedAudioRecorder;

- (void)startRecordingWithVolumeChangedBlock:(IMAudioRecordVolumedChangedBlock)aVolumedChangedBlock
                             completionBlock:(IMAudioRecordCompletionBlock)aCompletionBlock
                                 cancleBlock:(IMAudioRecordCancelBlock)aCancleBlock;
- (void)stopRecording;
- (void)cancelRecording;

@end

NS_ASSUME_NONNULL_END
