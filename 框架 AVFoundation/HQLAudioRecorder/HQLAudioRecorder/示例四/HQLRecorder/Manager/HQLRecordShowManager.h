//
//  HQLRecordShowManager.h
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//

#import <Foundation/Foundation.h>
#import "HQLRecorderHeaderDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQLRecordShowManager : NSObject

@property (nonatomic, assign) HQLRecordState recordState;

- (void)updatePower:(float)power;
- (void)updateRemainTime:(float)remainTime;

- (void)showToast:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
