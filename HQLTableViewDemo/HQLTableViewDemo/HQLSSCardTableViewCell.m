//
//  HQLSSCardTableViewCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2018/12/27.
//  Copyright © 2018 ToninTech. All rights reserved.
//

#import "HQLSSCardTableViewCell.h"
#import <YYKit.h>
#import <Masonry.h>
#import <Chameleon.h>

const CGFloat HQLSSCardTableViewCellHeight = 114;

@interface HQLSSCardTableViewCell () 

/** 蓝色背景视图 */
@property (nonatomic, strong) UIView *containerBGView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation HQLSSCardTableViewCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, HQLSSCardTableViewCellHeight);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIView *)containerBGView {
    if (!_containerBGView) {
        _containerBGView = [[UIView alloc] init];
        _containerBGView.backgroundColor = [UIColor colorWithHexString:@"#347DBC"];
        // 切圆角
        _containerBGView.layer.cornerRadius = 5.f;
        _containerBGView.layer.masksToBounds = NO;
    }
    return _containerBGView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.text = @"社会保障卡";
        _titleLable.font = [UIFont fontWithName:@"FZLSJW--GB1-0" size:24];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.backgroundColor = [UIColor clearColor];
    }
    return _titleLable;
}

- (UILabel *)cardTypeLabel {
    if (!_cardTypeLabel) {
        _cardTypeLabel = [[UILabel alloc] init];
        _cardTypeLabel.font = [UIFont systemFontOfSize:15];
        _cardTypeLabel.textAlignment = NSTextAlignmentCenter;
        _cardTypeLabel.textColor = [UIColor whiteColor];
        // 设置圆角
        _cardTypeLabel.layer.cornerRadius = 12;
        _cardTypeLabel.layer.masksToBounds = YES;
        // 设置边框
        _cardTypeLabel.layer.borderWidth = 1.0;
        _cardTypeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _cardTypeLabel;
}

- (UIImageView *)cardSelectedImageView {
    if (!_cardSelectedImageView) {
        UIImage *cardImage = [UIImage imageNamed:@"cardSelected"];
        _cardSelectedImageView = [[UIImageView alloc] initWithImage:cardImage];
        _cardSelectedImageView.contentMode = UIViewContentModeScaleAspectFit;
        _cardSelectedImageView.hidden = YES;
    }
    return _cardSelectedImageView;
}

- (UILabel *)idNumberLabel {
    if (!_idNumberLabel) {
        _idNumberLabel = [[UILabel alloc] init];
        _idNumberLabel.font = [UIFont systemFontOfSize:17];
        _idNumberLabel.textColor = [UIColor whiteColor];
        _idNumberLabel.backgroundColor = [UIColor clearColor];
        _idNumberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _idNumberLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

#pragma mark - Private

- (void)addSubviews {

    [self.contentView addSubview:self.containerBGView];
    [self.containerBGView addSubview:self.logoImageView];
    [self.containerBGView addSubview:self.titleLable];
    [self.containerBGView addSubview:self.cardTypeLabel];
    [self.containerBGView addSubview:self.nameLabel];
    [self.containerBGView addSubview:self.idNumberLabel];
    [self.containerBGView addSubview:self.cardSelectedImageView];
    
    [self.containerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(6);
        make.left.equalTo(self.contentView).with.offset(20);
        make.bottom.equalTo(self.contentView).with.offset(-6);
        make.right.equalTo(self.contentView).with.offset(-20);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerBGView).with.offset(17);
        make.left.equalTo(self.containerBGView).with.offset(21);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImageView.mas_centerY).with.offset(-6);
        make.left.equalTo(self.logoImageView.mas_right).with.offset(8);
    }];
    [self.cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable.mas_right).with.offset(6);
        make.centerY.equalTo(self.titleLable.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(54, 24));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(6);
        make.left.equalTo(self.titleLable);
    }];
    [self.idNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(6);
        make.left.equalTo(self.nameLabel);
    }];
    [self.cardSelectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerBGView);
        make.right.equalTo(self.containerBGView.mas_right).with.offset(-8);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
