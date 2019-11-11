//
//  HPMailCompositeHandCell.m
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/6.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "HPMailCompositeHandCell.h"

// Model
#import "HPMailModel.h"

// Utils
#import <Masonry.h>

const CGFloat HPMailCompositeHandCellHeight = 64;

@interface HPMailCompositeHandCell ()

@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *snippetLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *sectionButton;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIImageView *attachmentImageView;

@end

@implementation HPMailCompositeHandCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

#pragma mark - Custom Accessors

-(void)setModel:(HPMailModel *)model {
    _model = model;
    [self render];
}

- (UILabel *)emailLabel {
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    }
    return _emailLabel;
}

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [[UILabel alloc] init];
        _subjectLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _subjectLabel;
}

- (UILabel *)snippetLabel {
    if (!_snippetLabel) {
        _snippetLabel = [[UILabel alloc] init];
        _snippetLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _snippetLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _dateLabel;
}

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
    }
    return _statusImageView;
}

- (UIImageView *)attachmentImageView {
    if (!_attachmentImageView) {
        _attachmentImageView = [[UIImageView alloc] init];
    }
    return _attachmentImageView;
}

- (UIButton *)sectionButton {
    if (!_sectionButton) {
        _sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sectionButton addTarget:self action:@selector(sectionButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sectionButton;
}

#pragma mark - IBActions

- (void)sectionButtonDidClicked:(id)sender {
    
}

#pragma mark - Private

- (void)addSubviews {
    [self.contentView addSubview:self.statusImageView];
    [self.contentView addSubview:self.attachmentImageView];
    [self.contentView addSubview:self.sectionButton];
    [self.contentView addSubview:self.emailLabel];
    [self.contentView addSubview:self.subjectLabel];
    [self.contentView addSubview:self.snippetLabel];
    [self.contentView addSubview:self.dateLabel];
    
    CGSize size = CGSizeMake(12, 12);
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(4);
        make.left.mas_equalTo(self.contentView).with.offset(8);
        make.size.mas_equalTo(size);
    }];
    [self.attachmentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusImageView.mas_bottom).with.offset(4);
        make.left.equalTo(self.statusImageView);
        make.size.mas_equalTo(size);
    }];
    [self.sectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.attachmentImageView.mas_bottom).with.offset(4);
        make.left.equalTo(self.statusImageView);
        make.size.mas_equalTo(size);
    }];
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusImageView);
        make.left.equalTo(self.statusImageView.mas_right).with.offset(8);
        make.height.mas_equalTo(16);
    }];
    [self.subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.emailLabel);
        make.height.mas_equalTo(16);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailLabel);
        make.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 16));
        make.left.equalTo(self.subjectLabel.mas_right).with.offset(12);
    }];
}

- (void)render {
    self.emailLabel.text = self.model.email;
    self.subjectLabel.text = self.model.subject;
    self.snippetLabel.text = self.model.snippet;
    self.dateLabel.text= self.model.date;
    
    // 邮箱状态
    UIImage *statusImage = nil;
    switch (self.model.mailStatus) {
        case HPMailModelStatusUnread:
            statusImage = [UIImage imageNamed:@"mail_unread"];
            break;
        case HPMailModelStatusRead:
            statusImage = [UIImage imageNamed:@"mail_read"];
            break;
        case HPMailModelStatusReplied:
            statusImage = [UIImage imageNamed:@"mail_replied"];
            break;
    }
    self.statusImageView.image = statusImage;
    
    // 是否有附件
    UIImage *attachmentImage = nil;
    if (self.model.hasAttachment) {
        attachmentImage = [UIImage imageNamed:@"mail_attachment"];
    }
    self.attachmentImageView.image = attachmentImage;
    
    // 选中状态
    UIImage *selectedImage = [UIImage imageNamed:
        (self.model.isMailSelected ? @"mail_selected" : @"mail_unselected")];
    [self.sectionButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
}

@end
