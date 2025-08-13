//
//  HQLFlowLineView.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/8/13.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLFlowLineView.h"

// Framework
#import <YYKit.h>
#import "PocketSVG.h"

@interface HQLFlowLineView ()

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, assign) double duration;
@property (nonatomic, assign) NSInteger count; // 粒子数量
@property (nonatomic, assign) double delay; //？
@property (nonatomic, assign) NSInteger direction; // 动画执行方向, 1:正方向、-1:反方向、0:取消动画
@property (nonatomic, assign) BOOL isNight;
@property (nonatomic, strong) NSMutableArray<CALayer *> *dotArray;

@end

@implementation HQLFlowLineView

- (instancetype)initWithFrame:(CGRect)frame withSvgFile:(NSString *)fileName {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    self.dotArray = [[NSMutableArray alloc] init];
    [self private_setupBezierPathWithSvgFile:fileName];
    return self;
}

#pragma mark - Public

- (void)configWithCount:(NSInteger)count
                  delay:(double)delay
              direction:(NSInteger)direction
                isNight:(BOOL)isNight
{
    self.count = count;
    self.delay = delay;
    self.isNight = isNight;
    
    if (direction == -1) {
        self.bezierPath = self.bezierPath.bezierPathByReversingPath;
    }
    
    if (delay == 100) {
        self.lineLayer.strokeColor = UIColorHex(#1F2124).CGColor; // 纯黑色
        //供设备页，充电桩使用
    } else {
        if (isNight) {
            self.lineLayer.strokeColor = [UIColor blackColor].CGColor;
        } else {
            self.lineLayer.strokeColor = [UIColor colorWithRed:94/255.0 green:123/255.0 blue:137/255.0 alpha:1.0].CGColor;
        }
    }
    
    if (direction != 0) {
        __weak __typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf private_startAnimation];
        });
    } else {
        // 移除所有粒子动画
        for (CALayer *dotLayer in self.dotArray) {
            [dotLayer removeAllAnimations];
            [dotLayer removeFromSuperlayer];
        }
        [self.dotArray removeAllObjects];
    }
}

- (void)configWithLineColor:(UIColor *)color {
    self.lineLayer.strokeColor = color.CGColor;
}

#pragma mark - Private

- (void)private_setupBezierPathWithSvgFile:(NSString *)fileName {
    self.bezierPath = [UIBezierPath bezierPathWithCGPath:[PocketSVG pathFromSVGFileNamed:fileName]];
    
    // 绘制静态轨迹
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.lineWidth = 1.0; // 线宽
    self.lineLayer.fillColor = [UIColor clearColor].CGColor; // 填充颜色
    // 边框颜色，墨绿色（0x5E7B89, 80% ）
    self.lineLayer.strokeColor = [UIColor colorWithRed:94/255.0 green:123/255.0 blue:137/255.0 alpha:0.8].CGColor;
    self.lineLayer.path = [self.bezierPath CGPath];
    // 将 CAShapeLayer 添加到视图的图层中
    [self.layer addSublayer:self.lineLayer];
}

// 通过 CALayer 创建粒子，并在每个粒子上添加关键帧动画
- (void)private_startAnimation {
    // 移除所有粒子动画
    for (CALayer *dotLayer in self.dotArray) {
        [dotLayer removeAllAnimations];
        [dotLayer removeFromSuperlayer];
    }
    [self.dotArray removeAllObjects];
    
    CGPoint point = self.bezierPath.currentPoint;
    for (int index = 0; index < self.count; index++) {
        // 创建粒子
        CALayer *dotLayer = [CALayer layer];
        dotLayer.frame = CGRectMake(point.x, point.y, 2, 2);
        dotLayer.cornerRadius = 1.0;
        if (self.delay == 100) {
            dotLayer.frame = CGRectMake(point.x, point.y, 4, 4);
            dotLayer.backgroundColor = UIColorHex(0x50DAFF).CGColor; // 天蓝色？
        } else {
            CGFloat alphaValue = 1-(1.0f/self.count)*index;
            if (self.isNight) {
                // 天蓝色
                dotLayer.backgroundColor = [UIColor colorWithRed:80/255.0 green:218/255.0 blue:255/255.0 alpha:alphaValue].CGColor;
            } else {
                // 绿色
                dotLayer.backgroundColor = [UIColor colorWithRed:56/255.0 green:224/255.0 blue:161/255.0 alpha:alphaValue].CGColor;
            }
        }
        [self.layer addSublayer:dotLayer];
        [self.dotArray addObject:dotLayer];
        
        CAKeyframeAnimation *animation = [self animationWithIndex:index];
        [dotLayer addAnimation:animation forKey:nil];
    }
}

- (CAKeyframeAnimation *)animationWithIndex:(int)index {
    // 创建关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = self.bezierPath.CGPath;
    animation.repeatCount = MAXFLOAT;
    
    // 控制关键帧之间的插值方式
    // animation.calculationMode = kCAAnimationPaced; // 自动调整速度，使动画匀速
    animation.calculationMode = kCAAnimationCubicPaced; // 三次样条 + 匀速
    // 动画角度是否调整
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 2.0;
    animation.beginTime = CACurrentMediaTime() + 0.005 * index;
    // 匀速动画
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return animation;
}

@end
