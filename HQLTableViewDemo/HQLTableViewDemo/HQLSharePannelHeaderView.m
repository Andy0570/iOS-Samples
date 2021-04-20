//
//  HQLSharePannelHeaderView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/3/22.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLSharePannelHeaderView.h"
#import <Masonry.h>

@interface HQLSharePannelHeaderView ()

@property (nonatomic, strong) UIImageView *titleLineImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HQLSharePannelHeaderView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeSubviews];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIImageView *)titleLineImageView {
    if (!_titleLineImageView) {
        _titleLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"market_aihaodian"]];
        _titleLineImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _titleLineImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"分享至";
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

#pragma mark - Private

- (void)initializeSubviews {
    [self addSubview:self.titleLineImageView];
    [self addSubview:self.titleLabel];
    
    [self.titleLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(225, 1));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(55);
    }];
}

@end
