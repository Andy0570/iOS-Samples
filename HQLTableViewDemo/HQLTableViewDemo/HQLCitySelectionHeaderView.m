//
//  HQLCitySelectionHeaderView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCitySelectionHeaderView.h"
#import <UIColor+YYAdd.h>
#import <Masonry.h>

@interface HQLCitySelectionHeaderView ()
@property (nonatomic, strong)UILabel *headerTitleLabel;
@end

@implementation HQLCitySelectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.headerTitleLabel];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(15.0f);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - Custom Accessors

- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] init];
        _headerTitleLabel.font = [UIFont systemFontOfSize:15];
        _headerTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _headerTitleLabel;
}

#pragma mark - Public

- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    
    self.headerTitleLabel.text = headerTitle;
}

@end
