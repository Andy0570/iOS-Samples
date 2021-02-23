//
//  HQLRecordShowManager.m
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//

#import "HQLRecordShowManager.h"
#import "HQLRecordView.h"
#import "HQLRecordToastContentView.h"

@interface HQLRecordShowManager ()
@property (nonatomic, strong) HQLRecordView *recordView;
@property (nonatomic, strong) HQLRecordTipView *recordTipView;
@end

@implementation HQLRecordShowManager

- (void)setRecordState:(HQLRecordState)recordState {
    _recordState = recordState;
    
    if (recordState == HQLRecordStateNormal) {
        if (self.recordView.superview) {
            [self.recordView removeFromSuperview];
        }
        return;
    }
    
    if (!self.recordView.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.recordView];
    }
    
    [self.recordView updateRecordState:recordState];
}

#pragma mark - Public

- (void)updatePower:(float)power {
    [self.recordView updatePower:power];
}

- (void)updateRemainTime:(float)remainTime {
    [self.recordView updateRemainTime:remainTime];
}

- (void)showToast:(NSString *)message {
    if (!self.recordTipView.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.recordTipView];
        [self.recordTipView showMessage:message];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.recordTipView removeFromSuperview];
        });
    }
}

#pragma mark - Custom Accessors

- (HQLRecordView *)recordView {
    if (!_recordView) {
        _recordView = [[HQLRecordView alloc] init];
        _recordView.frame = CGRectMake(0, 0, 150, 150);
        _recordView.center = CGPointMake(round([UIScreen mainScreen].bounds.size.width / 2), round([UIScreen mainScreen].bounds.size.height / 2));
    }
    return _recordView;
}

- (HQLRecordTipView *)recordTipView {
    if (!_recordTipView) {
        _recordTipView = [[HQLRecordTipView alloc] init];
        _recordTipView.frame = CGRectMake(0, 0, 150, 150);
        _recordTipView.center = CGPointMake(round([UIScreen mainScreen].bounds.size.width / 2), round([UIScreen mainScreen].bounds.size.height / 2));
    }
    return _recordTipView;
}

@end
