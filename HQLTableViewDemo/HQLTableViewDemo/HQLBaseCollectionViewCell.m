//
//  HQLBaseCollectionViewCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/3/22.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLBaseCollectionViewCell.h"
#import "HQLTableViewGroupedModel.h"
#import <Masonry.h>
#import <Chameleon.h>

const CGFloat HQLBaseCollectionViewCellHeight = 90.0f;

@interface HQLBaseCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HQLBaseCollectionViewCell

#pragma mark - Initialize

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.imageView.image = nil;
    self.titleLabel.text = nil;
}

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
    [self configureModel];
}

#pragma mark - Private

- (void)initializeSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)configureModel {
    if (_navigationItem.image.length != 0) {
        self.imageView.image = [UIImage imageNamed:_navigationItem.image];
    }
    self.titleLabel.text = _navigationItem.title;
}

@end
