//
//  HQLCustomSegmentView.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/28.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLCustomSegmentView.h"

// Framework
#import <Masonry.h>
#import <YYKit.h>

@interface HQLCustomSegmentView ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *indicaterView; // 水平指示器
@property (nonatomic, strong) UIButton *currentSelectionButton;
@end

@implementation HQLCustomSegmentView

#pragma mark - Initialize

- (instancetype)initWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle {
    self = [super init];
    if (!self) { return nil; }
    
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    self.layer.backgroundColor = UIColorHex(0x1F2124).CGColor;
    self.layer.cornerRadius = 10.0f;
    
    self.currentSelectionButton = self.leftButton;
    
    [self addSubview:self.indicaterView];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [@[self.leftButton, self.rightButton] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:14 leadSpacing:18 tailSpacing:18];
    [@[self.leftButton, self.rightButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.indicaterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftButton);
        make.size.mas_equalTo(CGSizeMake(30, 4));
        make.bottom.equalTo(self.mas_bottom).offset(-4);
    }];
}

#pragma mark - Actions

- (void)buttonTapped:(UIButton *)button {
    if (button != self.currentSelectionButton) {
        [self selectItemAtIndex:button.tag executeCompletionBlock:YES];
    }
}

#pragma mark - Public

- (void)selectItemAtIndex:(NSUInteger)index {
    [self selectItemAtIndex:index executeCompletionBlock:NO];
}

#pragma mark - Private

- (void)selectItemAtIndex:(NSUInteger)index executeCompletionBlock:(BOOL)execute {
    self.currentSelectionButton.selected = NO;
    if (index == 0) {
        self.currentSelectionButton = self.leftButton;
    } else {
        self.currentSelectionButton = self.rightButton;
    }
    self.currentSelectionButton.selected = YES;
    
    [UIView animateKeyframesWithDuration:0.3
                                   delay:0.01
                                 options:UIViewKeyframeAnimationOptionLayoutSubviews
                              animations:^{
        self.indicaterView.centerX = self.currentSelectionButton.centerX;
    } completion:^(BOOL finished) {
        if (execute && self.selectBlock) {
            self.selectBlock(index);
        }
    }];
}

#pragma mark - Custom Accessors

- (UIView *)indicaterView {
    if (!_indicaterView) {
        _indicaterView = [[UIView alloc] init];
        _indicaterView.layer.backgroundColor = UIColorHex(0x4FE1FF).CGColor;
        _indicaterView.layer.cornerRadius = 2.0;
    }
    return _indicaterView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_leftButton setTitleColor:UIColorHex(0x7B7B7B) forState:UIControlStateNormal];
        [_leftButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateSelected];
        _leftButton.backgroundColor = [UIColor clearColor];
        _leftButton.tag = 0;
        _leftButton.selected = YES;
        
        // 设置按钮圆角
        _leftButton.layer.cornerRadius = 8.f;
        _leftButton.layer.masksToBounds = YES;
        
        [_leftButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_rightButton setTitleColor:UIColorHex(0x7B7B7B) forState:UIControlStateNormal];
        [_rightButton setTitleColor:UIColorHex(0xFFFFFF) forState:UIControlStateSelected];
        _rightButton.backgroundColor = [UIColor clearColor];
        _rightButton.tag = 1;
        
        // 设置按钮圆角
        _rightButton.layer.cornerRadius = 8.f;
        _rightButton.layer.masksToBounds = YES;
        
        [_rightButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
