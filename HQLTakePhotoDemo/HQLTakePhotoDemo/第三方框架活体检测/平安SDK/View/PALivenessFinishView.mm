//
//  PALivenessFinishView.m
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/3/30.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "PALivenessFinishView.h"
#import "PALivenessFinishAnimationView.h"
#import <YYKit.h>

@interface PALivenessFinishView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailPromptLabel;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *recheckButton;

@property (nonatomic, strong) PALivenessFinishAnimationView *animationView;
@property (nonatomic, weak) id<PALivenessFinishViewDelegate> delegate;

@end

@implementation PALivenessFinishView

#pragma mark - Lifecycle

- (void)dealloc {
    self.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<PALivenessFinishViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    
    // 使用 Mansory 框架布局
    
//    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).with.offset(40);
//        }else {
//            make.top.equalTo(self.mas_top).with.offset(40);
//        }
//        make.left.equalTo(self.mas_left).with.offset(15);
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//    }];
//    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.backButton.mas_bottom).with.offset(40);
//        make.left.mas_equalTo(self.mas_left).with.offset(CGFloatPixelRound(kScreenWidth/2 - 150/2));
//        make.size.mas_equalTo(CGSizeMake(150, 150));
//    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.animationView.mas_bottom).with.offset(50);
//        make.centerX.mas_equalTo(self.mas_centerX);
//    }];
//    [self.detailPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(20);
//        make.centerX.mas_equalTo(self.mas_centerX);
//    }];
//    [self.recheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.mas_left).with.offset(40);
//        make.right.mas_equalTo(self.mas_right).with.offset(-40);
//        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-80);
//        make.height.mas_equalTo(45);
//    }];
}

#pragma mark - Custom Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _titleLabel.textColor = [UIColor colorWithRed:93/255.0 green:88/255.0 blue:88/255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

- (UILabel *)detailPromptLabel {
    if (!_detailPromptLabel) {
        _detailPromptLabel = [[UILabel alloc] init];
        _detailPromptLabel.text = @"请保证拍摄光线良好\n正对摄像头保持相对静止";
        _detailPromptLabel.font = [UIFont boldSystemFontOfSize:17];
        _detailPromptLabel.textColor = [UIColor grayColor];
        _detailPromptLabel.textAlignment = NSTextAlignmentCenter;
        _detailPromptLabel.numberOfLines = 3;
        _detailPromptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _detailPromptLabel;
}

- (PALivenessFinishAnimationView *)animationView {
    if (!_animationView) {
        // 150*150
        CGRect rect = CGRectMake(CGFloatPixelRound(kScreenWidth/2 - 150/2), 80, 150, 150);
        _animationView = [[PALivenessFinishAnimationView alloc] initWithFrame:rect];
    }
    return _animationView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        // 20*20
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"password_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)recheckButton {
    if (!_recheckButton) {
        _recheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recheckButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_recheckButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [_recheckButton setTitle:@"重新检测 " forState:UIControlStateNormal];
        _recheckButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_recheckButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recheckButton addTarget:self action:@selector(recheckButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recheckButton;
}

#pragma mark - IBActions

// 返回按钮
- (void)backButtonDidClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishViewBackButtonDidClicked)]) {
        [self.delegate finishViewBackButtonDidClicked];
    }
}

// 重新检测按钮
- (void)recheckButtonDidClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishViewRecheckButtonDidClicked)]) {
        [self.delegate finishViewRecheckButtonDidClicked];
    }
}

#pragma mark - Public

//typedef NS_ENUM(NSUInteger, PALivenessControllerDetectionFailureType) {
//    PALivenessControllerDetectionFailureTypeActionBlend,         // 动作错误
//    PALivenessControllerDetectionFailureTypeDiscontinuityAttack, // 非连续性攻击
//    PALivenessControllerDetectionFailureTypeTimeOut,             // 检测超时
//    PALivenessControllerDetectionFailureTypeCameraDenied,        // 相机权限获取失败
//};
- (void)setFailureType:(PALivenessControllerDetectionFailureType)FailureType {
    switch (FailureType) {
        case PALivenessControllerDetectionFailureTypeActionBlend: {
            self.titleLabel.text = @"动作错误（01）";
            break;
        }
        case PALivenessControllerDetectionFailureTypeDiscontinuityAttack: {
            self.titleLabel.text = @"动作幅度过大（02）";
            break;
        }
        case PALivenessControllerDetectionFailureTypeTimeOut: {
            self.titleLabel.text = @"检测失败（03）";
            break;
        }
        case PALivenessControllerDetectionFailureTypeCameraDenied: {
            self.titleLabel.text = @"相机权限获取失败（04）";
            break;
        }
    }
    [self.animationView animationWithFailure];
}

#pragma mark - Private

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backButton];
    [self addSubview:self.animationView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailPromptLabel];
    [self addSubview:self.recheckButton];
}

@end
