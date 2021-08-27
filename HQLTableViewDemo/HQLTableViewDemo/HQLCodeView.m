//
//  HQLCodeView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCodeView.h"
#import <Masonry.h>
#import <Chameleon.h>

@implementation HQLCodeView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.userInteractionEnabled = NO;
        
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    [self addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).with.offset(-10.0f);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(2.0f);
    }];
}

#pragma mark - Custom Accessors

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textColor = HexColor(@"#108EE9");
        _codeLabel.font = [UIFont systemFontOfSize:25.0f];
        _codeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _codeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.grayColor;
    }
    return _lineView;
}

- (void)setText:(NSString *)text {
    if (text.length > 0) {
        self.codeLabel.text = [text substringToIndex:1]; // 只取一位数
        self.lineView.backgroundColor = HexColor(@"#108EE9");
    } else {
        self.codeLabel.text = @"";
        self.lineView.backgroundColor = UIColor.grayColor;
    }
}

@end
