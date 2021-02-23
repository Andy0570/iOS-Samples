//
//  HQLRecordView.h
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//

#import <UIKit/UIKit.h>
#import "HQLRecorderHeaderDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQLRecordView : UIView

- (void)updateRecordState:(HQLRecordState)state;
- (void)updatePower:(float)power;
- (void)updateRemainTime:(float)remainTime;

@end

NS_ASSUME_NONNULL_END
