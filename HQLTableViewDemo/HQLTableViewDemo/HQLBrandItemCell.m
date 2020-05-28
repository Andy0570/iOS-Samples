//
//  HQLBrandItemCell.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/15.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBrandItemCell.h"

// Frameworks
#import <Masonry.h>
#import <YYKit.h>
#import <SDWebImage.h>

// Models
#import "HQLBrandModel.h"

@interface HQLBrandItemCell ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HQLBrandItemCell

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(5);
        make.centerX.mas_equalTo(self);
        
        CGFloat length = CGFloatPixelRound(self.width * 0.85);
        make.size.mas_equalTo(CGSizeMake(length, length));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(self);
        make.left.and.right.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


#pragma mark - Custom Accessors

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _logoImageView.image = [UIImage imageNamed:@"trash"];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setBrandModel:(HQLBrandModel *)brandModel {
    _brandModel = brandModel;
    
    // 品牌 Logo 图片
    UIImage *defaultImage = [UIImage imageNamed:@"trash"];
    NSURL *logoUrl = brandModel.logoUrl;
    BOOL isUrlValid = logoUrl && [logoUrl scheme] && [logoUrl host];
    if (isUrlValid) {
        [self.logoImageView sd_setImageWithURL:logoUrl placeholderImage:defaultImage];
    } else {
        self.logoImageView.image = defaultImage;
    }
    
    // 品牌名称
    self.titleLabel.text = brandModel.name;
}


@end
