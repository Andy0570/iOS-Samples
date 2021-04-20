//
//  HQLMineServiceNameHeaderView.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/30.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMineServiceNameHeaderView.h"
#import <Masonry.h>

// |-7-17-7-| = 31
const CGFloat HQLMineServiceNameHeaderViewHeight = 32.0f;

@interface HQLMineServiceNameHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HQLMineServiceNameHeaderView

#pragma mark - Initialize

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.title = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    [self setupSubview];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) { return nil; }
    [self setupSubview];
    return self;
}

#pragma mark - Custom Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - Private

- (void)setupSubview {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

@end
