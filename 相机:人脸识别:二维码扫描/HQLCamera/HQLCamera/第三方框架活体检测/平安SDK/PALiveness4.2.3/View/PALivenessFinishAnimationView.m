//
//  PALivenessFinishAnimationView.m
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/3/30.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "PALivenessFinishAnimationView.h"
#import <YYKit.h>

static NSString *const KAnimationKey = @"strokeEnd"; //第一步完成动画的名字

@interface PALivenessFinishAnimationView ()

@property (nonatomic) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PALivenessFinishAnimationView

#pragma mark - Lifecycle

- (instancetype)init {
    return [[PALivenessFinishAnimationView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.circleLayer];
        [self addSubview:self.imageView];
    }
    return self;
}



#pragma mark - Custom Accessors

// 圆形图层
- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        CGFloat lineWidth = 3.f;
        CGFloat radius = CGRectGetWidth(self.bounds) / 2 - lineWidth / 2; // 半径
        CGRect rect = CGRectMake(0, 0, radius * 2, radius *2);
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath; // 绘制贝塞尔曲线路径
        _circleLayer.strokeColor = [UIColor clearColor].CGColor; // 描边色，默认无色
        _circleLayer.fillColor = [UIColor clearColor].CGColor;   // 填充色，默认黑色
        _circleLayer.lineWidth = lineWidth;
        _circleLayer.lineCap = kCALineCapRound;   // 线端点类型
        _circleLayer.lineJoin = kCALineJoinRound; // 线连接类型
        _circleLayer.strokeStart = 0;  // 圆的起始位置，默认0
        _circleLayer.strokeEnd = 1;    // 圆的结束为止，默认1
    }
    return _circleLayer;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = self.frame.size.width / 2; // 设置圆角
        _imageView.layer.borderWidth = 0;     // 边框宽度
        _imageView.layer.borderColor = [UIColor clearColor].CGColor; // 边框颜色
        _imageView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1); // 缩放图像,0.1倍
    }
    return _imageView;
}

#pragma mark - Public

- (void)animationWithSuccess {
    [self animationWithResult:YES];
}

- (void)animationWithFailure {
    [self animationWithResult:NO];
}

#pragma mark - Private

- (void)animationWithResult:(BOOL)result {
    if (result) {
        self.circleLayer.strokeColor = [UIColor colorWithHexString:@"#7BE4AF"].CGColor;
        self.imageView.image = [UIImage imageNamed:@"PALiveness_success"];
    }else {
        self.circleLayer.strokeColor = [UIColor colorWithHexString:@"#EF9294"].CGColor;
        self.imageView.image = [UIImage imageNamed:@"PALIveness_failure"];
    }
    
    // 圆圈动画
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:KAnimationKey];
    drawAnimation.duration            = 0.5f;
    drawAnimation.repeatCount         = 1.0;
    drawAnimation.removedOnCompletion = YES;
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.circleLayer addAnimation:drawAnimation forKey:KAnimationKey];
    
    // 图片动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.25 animations:^{
            // 图片放大1.2倍
            self.imageView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                // 图片还原到默认大小
                self.imageView.layer.transform = CATransform3DIdentity;
            }];
        }];
    });
}

@end
