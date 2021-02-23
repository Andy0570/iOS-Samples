//
//  HQLRecordPowerAnimationView.m
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//

#import "HQLRecordPowerAnimationView.h"

@interface HQLRecordPowerAnimationView ()
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation HQLRecordPowerAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    self.contentImageView = [[UIImageView alloc] init];
    self.contentImageView.image = [UIImage imageNamed:@"ic_record_ripple"];
    [self addSubview:self.contentImageView];
    
    self.maskLayer = [[CAShapeLayer alloc] init];
    self.maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentImageView.frame = self.bounds;
}

- (void)updatePower:(float)power {
    int viewCount = ceil(fabs(power) * 10);
    if (viewCount == 0) {
        viewCount = 1;
    } else if (viewCount > 9) {
        viewCount = 9;
    }
    
    CGFloat itemHeight = 6;
    CGFloat maskHeight = itemHeight * viewCount;
    
    // 从下往上画线
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.contentImageView.frame.size.height, self.contentImageView.frame.size.width, -maskHeight)];
    self.maskLayer.path = path.CGPath;
    self.contentImageView.layer.mask = self.maskLayer;
}

@end
