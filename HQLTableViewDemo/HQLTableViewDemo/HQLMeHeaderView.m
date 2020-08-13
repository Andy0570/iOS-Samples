//
//  HQLMeHeaderView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/24.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLMeHeaderView.h"
#import <YYKit.h>
#import <Chameleon.h>
#import <Masonry.h>

static const CGFloat KHeaderViewHeight = 165;

@interface HQLMeHeaderView ()

@property (nonatomic, strong) UIImageView *headerImageView;
//代码约束
@property (nonatomic, strong) MASConstraint *codeConstraintHeight;
@property (nonatomic, assign) CGFloat originalHeaderImageViewHeight;

@end

@implementation HQLMeHeaderView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.image = [UIImage imageNamed:@"yoona"];
        _headerImageView.clipsToBounds = YES;
    }
    return _headerImageView;
}

#pragma mark - Private

- (void)setupUI {
    self.frame = CGRectMake(0, 0, kScreenWidth, KHeaderViewHeight);
    
    [self addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self);
        self.codeConstraintHeight = make.height.equalTo(@(self.bounds.size.height));
    }];
    self.originalHeaderImageViewHeight = self.bounds.size.height;
}

#pragma mark - Public

- (void)updateHeaderImageViewFrameWithOffsetY:(CGFloat)offsetY {
    //防止height小于0
    if (self.originalHeaderImageViewHeight - offsetY < 0) {
        return;
    }
    
    // 第一种方式：获取到这个约束，直接对约束值修改
    // self.codeConstraintHeight.equalTo(@(self.originalHeaderImageViewHeight -offsetY));
    // 第二种方式：直接使用 Masonry 提供的更新约束方法，其实原理是一样的
    [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.originalHeaderImageViewHeight - offsetY));
    }];
}

@end
