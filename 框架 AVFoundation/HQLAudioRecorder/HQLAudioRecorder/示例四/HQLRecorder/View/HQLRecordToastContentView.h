//
//  HQLRecordToastContentView.h
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//  中央容器视图中的各子视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLRecordToastContentView : UIView
@end

@interface HQLRecordingView : HQLRecordToastContentView
- (void)updatePower:(float)power;
@end

@interface HQLRecordReleaseToCancelView : HQLRecordToastContentView
@end

@interface HQLRecordCountingView : HQLRecordToastContentView
- (void)updateRemainTime:(float)remainTime;
@end

@interface HQLRecordTipView : HQLRecordToastContentView
- (void)showMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
