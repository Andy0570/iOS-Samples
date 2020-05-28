//
//  HQLBrandListCategoryCell.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/15.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLBrandListCategoryCell.h"

// Frameworks
#import <Masonry.h>
#import <YYKit.h>
#import <Chameleon.h>

const CGFloat HQLBrandListCategoryCellHeight = 50.0f;

@interface HQLBrandListCategoryCell ()

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HQLBrandListCategoryCell

#pragma mark - Initialize

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.indicatorView];
    [self.contentView addSubview:self.titleLabel];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(6);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];
}


#pragma mark - Custom Accessors

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = HexColor(@"#47c1b6");
    }
    return _indicatorView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _titleLabel;
}

- (void)setName:(NSString *)name {
    _name = name;
    
    // 品类标题
    self.titleLabel.text = [name isNotBlank] ? name : @"其他";
}

#pragma mark - Override

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.indicatorView.hidden = NO;
        self.titleLabel.textColor = HexColor(@"#47c1b6");
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.indicatorView.hidden = YES;
        self.titleLabel.textColor = rgb(51, 51, 51);
        self.backgroundColor = HexColor(@"#F9F9F9");
    }
}

@end
