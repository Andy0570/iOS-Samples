//
//  HQLRecordToastContentView.m
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//

#import "HQLRecordToastContentView.h"
#import "HQLRecordPowerAnimationView.h"

@implementation HQLRecordToastContentView
@end

@interface HQLRecordingView ()
@property (nonatomic, strong) UIImageView *recordImageView; // 话筒图片
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) HQLRecordPowerAnimationView *powerView; // 声音波动视图
@end

@implementation HQLRecordingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setup];
    return self;
}

- (void)setup {
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = @"手指上滑 取消发送";
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.contentLabel];
    
    self.recordImageView = [[UIImageView alloc] init];
    self.recordImageView.image = [UIImage imageNamed:@"ic_record"];
    [self addSubview:self.recordImageView];
    
    self.powerView = [[HQLRecordPowerAnimationView alloc] init];
    [self addSubview:self.powerView];
    
    // 默认显示一格音量
    [self.powerView updatePower:1];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentLabel sizeToFit];
    self.contentLabel.frame = CGRectMake(0, self.frame.size.height - self.contentLabel.frame.size.height - 12, self.frame.size.width, self.contentLabel.frame.size.height);
    
    self.recordImageView.frame = CGRectMake(40, 30, self.recordImageView.image.size.width, self.recordImageView.image.size.height);
    
    self.powerView.frame = CGRectMake(self.recordImageView.frame.origin.x + self.recordImageView.frame.size.width + 6, self.recordImageView.frame.origin.y + self.recordImageView.frame.size.height - 56, 29, 54);
}

- (void)updatePower:(float)power {
    [self.powerView updatePower:power];
}

@end

@interface HQLRecordReleaseToCancelView ()
@property (nonatomic, strong) UIImageView *releaseImageView; // 撤销图片
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation HQLRecordReleaseToCancelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setup];
    return self;
}

- (void)setup {
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    self.contentLabel.text = @"松开手指 取消发送";
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.layer.cornerRadius = 2;
    self.contentLabel.layer.masksToBounds = YES;
    [self addSubview:self.contentLabel];
    
    self.releaseImageView = [[UIImageView alloc] init];
    self.releaseImageView.image = [UIImage imageNamed:@"ic_release_to_cancel"];
    [self addSubview:self.releaseImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.releaseImageView.frame = CGRectMake(round((self.frame.size.width - self.releaseImageView.image.size.width) * 0.5), 30, self.releaseImageView.image.size.width, self.releaseImageView.image.size.height);
    
    self.contentLabel.frame = CGRectMake(6, self.frame.size.height - 25 - 7, self.frame.size.width - 12, 25);
}

@end

@interface HQLRecordCountingView ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *remainTimeLabel;
@end

@implementation HQLRecordCountingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setup];
    return self;
}

- (void)setup {
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = @"松开手指 取消发送";
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.layer.cornerRadius = 2;
    self.contentLabel.layer.masksToBounds = YES;
    [self addSubview:self.contentLabel];
    
    self.remainTimeLabel = [[UILabel alloc] init];
    self.remainTimeLabel.font = [UIFont boldSystemFontOfSize:80];
    self.remainTimeLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.remainTimeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentLabel.frame = CGRectMake(6, self.frame.size.height - 25 - 7, self.frame.size.width - 12, 25);
    
    [self.remainTimeLabel sizeToFit];
    self.remainTimeLabel.frame = CGRectMake(round((self.frame.size.width - self.remainTimeLabel.frame.size.width) * 0.5), 16, self.remainTimeLabel.frame.size.width, 95);
}

- (void)updateRemainTime:(float)remainTime {
    self.remainTimeLabel.text = [NSString stringWithFormat:@"%d",(int)remainTime];
    [self setNeedsLayout];
}

@end

@interface HQLRecordTipView ()
@property (nonatomic, strong) UIImageView *alertImageView; // 录音太短提示
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation HQLRecordTipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    [self setup];
    return self;
}

- (void)setup {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = @"说话时间太短";
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.contentLabel];
    
    self.alertImageView = [[UIImageView alloc] init];
    self.alertImageView.image = [UIImage imageNamed:@"ic_record_too_short"];
    [self addSubview:self.alertImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.alertImageView.frame = CGRectMake(round((self.frame.size.width - self.alertImageView.frame.size.width) * 0.5), 32, self.alertImageView.image.size.width, self.alertImageView.image.size.height);
    
    self.contentLabel.frame = CGRectMake(0, self.frame.size.height - 25 - 7, self.frame.size.width, 25);
}

- (void)showMessage:(NSString *)message {
    self.contentLabel.text = message;
    [self setNeedsLayout];
}

@end
