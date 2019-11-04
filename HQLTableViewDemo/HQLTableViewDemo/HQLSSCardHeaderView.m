//
//  HQLSSCardHeaderView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/12/29.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import "HQLSSCardHeaderView.h"

// Frameworks
#import <YYKit.h>
#import <Masonry.h>

const CGFloat HQLSSCardHeaderViewHeight = 58;

@interface HQLSSCardHeaderView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HQLSSCardHeaderView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, HQLSSCardHeaderViewHeight);
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

#pragma mark - Custom Accessors

// 46*34
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card_logo"]];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"卡";
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

#pragma mark - Private

- (void)addSubviews {
    [self addSubview:self.logoImageView];
    [self addSubview:self.titleLabel];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(23);
        make.left.equalTo(self).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(27, 17));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImageView);
        make.left.equalTo(self.logoImageView.mas_right).with.offset(15);
    }];
}


@end
