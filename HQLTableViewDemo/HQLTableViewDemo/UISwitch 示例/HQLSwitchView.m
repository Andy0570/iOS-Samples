//
//  HQLSwitchView.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/4/1.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLSwitchView.h"

@interface HQLSwitchView ()
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, assign, getter=isFirstLoad) BOOL firstLoad;
@end

@implementation HQLSwitchView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    self.firstLoad = YES;
    self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    self.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = self.bounds.size.height / 2.0f;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.switchButton];
    self.switchButton.layer.cornerRadius = self.switchButton.bounds.size.height / 2.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchButtonTapped:)];
    [self addGestureRecognizer:tap];
    return self;
}

#pragma mark - Actions

- (void)switchButtonTapped:(id)sender {
    self.on = !self.isOn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchView:didChangeValue:)]) {
        [self.delegate switchView:self didChangeValue:self.isOn];
    }
}

#pragma mark - Private

- (void)animationSwitchButton {
    if (self.isOn) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotationAnimation.fromValue = [NSNumber numberWithFloat:-M_PI];
            rotationAnimation.toValue = [NSNumber numberWithFloat:0.0];
            rotationAnimation.duration = 0.45;
            rotationAnimation.cumulative = NO;
            [self.switchButton.layer addAnimation:rotationAnimation forKey:@"rotate"];
            
            self.backgroundColor = [UIColor colorWithRed:0/255.0 green:141/255.0 blue:150/255.0 alpha:1];
            self.layer.borderColor = [UIColor colorWithRed:0/255.0 green:141/255.0 blue:150/255.0 alpha:1].CGColor;
            self.layer.borderWidth = 1.0f;
            self.layer.masksToBounds = YES;
            
            self.switchButton.selected = YES;
            self.switchButton.frame = CGRectMake(self.bounds.size.width - self.bounds.size.height, 0, self.bounds.size.height, self.bounds.size.height);
        } completion:^(BOOL finished) {
            self.switchButton.selected = YES;
            self.switchButton.frame = CGRectMake(self.bounds.size.width - self.bounds.size.height, 0, self.bounds.size.height, self.bounds.size.height);
        }];
    } else {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotationAnimation.toValue = [NSNumber numberWithFloat:-M_PI];
            rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
            rotationAnimation.duration = 0.45;
            rotationAnimation.cumulative = NO;
            [self.switchButton.layer addAnimation:rotationAnimation forKey:@"rotate"];
            
            self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
            self.layer.borderColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1].CGColor;
            self.layer.borderWidth = 1.0f;
            self.layer.masksToBounds = YES;
            
            self.switchButton.selected = NO;
            self.switchButton.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
        } completion:^(BOOL finished) {
            self.switchButton.selected = NO;
            self.switchButton.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
        }];
    }
}

#pragma mark - Custom Accessors

- (void)setOn:(BOOL)on {
    _on = on;
    
    if (_on && self.isFirstLoad) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:141/255.0 blue:150/255.0 alpha:1];
        self.layer.borderColor = [UIColor colorWithRed:0/255.0 green:141/255.0 blue:150/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.masksToBounds = YES;
        
        self.switchButton.selected = YES;
        self.switchButton.frame = CGRectMake(self.bounds.size.width - self.bounds.size.height, 0, self.bounds.size.height, self.bounds.size.height);
        self.firstLoad = NO;
    } else {
        [self animationSwitchButton];
        self.firstLoad = NO;
    }
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchButton.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
        // 随便找的图片
        [_switchButton setImage:[UIImage imageNamed:@"pay_failure"] forState:UIControlStateNormal];
        [_switchButton setImage:[UIImage imageNamed:@"pay_succeed"] forState:UIControlStateSelected];
        
        [_switchButton addTarget:self
                          action:@selector(switchButtonTapped:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

@end
