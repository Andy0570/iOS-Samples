//
//  HQLRecordView.m
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//

#import "HQLRecordView.h"
#import "HQLRecordToastContentView.h"

@interface HQLRecordView ()

@property (nonatomic, strong) HQLRecordingView *recordingView;
@property (nonatomic, strong) HQLRecordReleaseToCancelView *releaseToCancelView;
@property (nonatomic, strong) HQLRecordCountingView *countingView;
@property (nonatomic, assign) HQLRecordState currentState;

@end

@implementation HQLRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setup];
    return self;
}

- (void)setup {
    self.currentState = HQLRecordStateNormal;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    self.recordingView = [[HQLRecordingView alloc] init];
    [self addSubview:self.recordingView];
    self.recordingView.hidden = YES;
    
    self.releaseToCancelView = [[HQLRecordReleaseToCancelView alloc] init];
    [self addSubview:self.releaseToCancelView];
    self.releaseToCancelView.hidden = YES;
    
    self.countingView = [[HQLRecordCountingView alloc] init];
    [self addSubview:self.countingView];
    self.countingView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.recordingView.frame = self.bounds;
    self.releaseToCancelView.frame = self.bounds;
    self.countingView.frame = self.bounds;
}

#pragma mark - Public

- (void)updateRecordState:(HQLRecordState)state {
    self.currentState = state;
    
    switch (self.currentState) {
        case HQLRecordStateNormal:
        case HQLRecordStateRecordTooShort: {
            self.recordingView.hidden = YES;
            self.releaseToCancelView.hidden = YES;
            self.countingView.hidden = YES;
            break;
        }
        case HQLRecordStateRecording: {
            self.recordingView.hidden = NO;
            self.releaseToCancelView.hidden = YES;
            self.countingView.hidden = YES;
            break;
        }
        case HQLRecordStateReleaseToCancel: {
            self.recordingView.hidden = YES;
            self.releaseToCancelView.hidden = NO;
            self.countingView.hidden = YES;
            break;
        }
        case HQLRecordStateRecordCounting: {
            self.recordingView.hidden = YES;
            self.releaseToCancelView.hidden = YES;
            self.countingView.hidden = NO;
            break;
        }
    }
}

- (void)updatePower:(float)power {
    if (self.currentState != HQLRecordStateRecording) { return; }
    
    [self.recordingView updatePower:power];
}

- (void)updateRemainTime:(float)remainTime {
    if (self.currentState != HQLRecordStateRecordCounting || !self.releaseToCancelView.hidden) {
        return;
    }
    [self.countingView updateRemainTime:remainTime];
}

@end
