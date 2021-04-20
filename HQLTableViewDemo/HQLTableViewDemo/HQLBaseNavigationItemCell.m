//
//  HQLBaseNavigationItemCell.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/9/10.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBaseNavigationItemCell.h"
#import "HQLTableViewGroupedModel.h"
#import <Masonry.h>
#import <Chameleon.h>
#import <YYKit.h>

const CGFloat HQLBaseNavigationItemHeight = 90.0f;

@interface HQLBaseNavigationItemCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HQLBaseNavigationItemCell

#pragma mark - Initialize

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.imageView.image = nil;
    self.titleLabel.text = nil;
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

- (void)setupSubview {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // |-10-60-0-17-3-|
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(10);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-3);
    }];
}

#pragma mark - Custom Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.textColor = HexColor(@"#333333");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setNavigationItem:(HQLTableViewModel *)navigationItem {
    _navigationItem = navigationItem;
    [self configureSubview];
}

- (void)configureSubview {
    if ([_navigationItem.image isNotBlank]) {
        self.imageView.image = [UIImage imageNamed:_navigationItem.image];
    }
    if ([_navigationItem.title isNotBlank]) {
        self.titleLabel.text = _navigationItem.title;
    }
}

@end
