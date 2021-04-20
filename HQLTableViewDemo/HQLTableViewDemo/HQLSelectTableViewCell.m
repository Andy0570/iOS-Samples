//
//  HQLSelectTableViewCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/4/1.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLSelectTableViewCell.h"
#import <Masonry.h>

@interface HQLSelectTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *accessoryImageView;

@end

@implementation HQLSelectTableViewCell

#pragma mark - Initialize

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) { return nil; }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.accessoryImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.accessoryImageView.hidden = !selected;
}

#pragma mark - Custom Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _titleLabel;
}

- (UIImageView *)accessoryImageView {
    if (!_accessoryImageView) {
        _accessoryImageView = [[UIImageView alloc] init];
        _accessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
        _accessoryImageView.image = [UIImage imageNamed:@"button_select"];
    }
    return _accessoryImageView;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
