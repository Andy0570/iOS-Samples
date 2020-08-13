//
//  HQLSuspensionButton.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/8/8.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLSuspensionButton.h"
#define kTouchWidth self.frame.size.width
#define kTouchHeight self.frame.size.height

@implementation HQLSuspensionButton

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = color;
        self.alpha = 1.0;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        // 添加拖动手势
        [self addPanGestureRecognizer];
    }
    return self;
}

- (void)addPanGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePosition:)];
    panGestureRecognizer.delaysTouchesBegan = YES;
    [self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Actions

- (void)changePosition:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [panGestureRecognizer locationInView:window];
    
    // 更新透明度
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.alpha = 1;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.alpha = 0.5;
    }
    
    // 更新位置
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs([UIScreen mainScreen].bounds.size.width - left);
        // 只停留在左右两侧，需要在上下两侧，将注释打开
        // CGFloat top = fabs(panPoint.y);
        // CGFloat bottom = fabs([UIScreen mainScreen].bounds.size.height - top);
        
        CGFloat minSpace = MIN(left, right);
        // CGFloat minSpace = MIN(MIN(MIN(top, left), bottom), right);
        CGPoint newCenter;
        CGFloat targetY = 0;
        
        // 校正 Y
        if (panPoint.y < (15 + self.frame.size.height/2.0)) {
            targetY =  15 + self.frame.size.height/2.0;
        } else if (panPoint.y > [UIScreen mainScreen].bounds.size.height - self.frame.size.height/2.0 - 15) {
            targetY = [UIScreen mainScreen].bounds.size.height - self.frame.size.height/2.0 - 15;
        } else {
            targetY = panPoint.y;
        }
        
        if (minSpace == left) {
            newCenter = CGPointMake(self.frame.size.height/3  + 20, targetY);
        } else {
            newCenter = CGPointMake([UIScreen mainScreen].bounds.size.width - self.frame.size.height/3 - 20, targetY);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.center = newCenter;
        }];
        
    }
}

#pragma mark - Public

- (void)show {
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
    [mainWindow addSubview:self];
}

@end
