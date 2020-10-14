//
//  HQLTopicFooterView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/12.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTopicFooterView.h"
#import <Chameleon.h>
#import <Masonry.h>

@interface HQLTopicFooterView () 
@property (nonatomic, strong) UIView *lineView;
@end

@implementation HQLTopicFooterView

#pragma mark - Initialize

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@1);
    }];
}

#pragma mark - Custom Accessors

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(@"#d6d7dc");
    }
    return _lineView;
}

#pragma mark - Private

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.lineView];
}


@end
