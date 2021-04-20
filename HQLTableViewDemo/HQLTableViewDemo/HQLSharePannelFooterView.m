//
//  HQLSharePannelFooterView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/3/22.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLSharePannelFooterView.h"
#import <Masonry.h>
#import <Chameleon.h>

@interface HQLSharePannelFooterView ()
@property (nonatomic, strong) UIButton *cancelButton;
@end

@implementation HQLSharePannelFooterView

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

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:HexColor(@"#888888") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark - Actions

- (void)cancelButtonAction:(id)sender {
    if (self.cancelButtonActionBlock) {
        self.cancelButtonActionBlock();
    }
}

#pragma mark - Private

- (void)setupUI {
    self.backgroundColor = HexColor(@"#F5F5F9");
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

@end
