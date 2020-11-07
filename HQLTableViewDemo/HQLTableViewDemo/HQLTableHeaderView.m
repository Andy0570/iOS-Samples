//
//  HQLTableHeaderView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/15.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTableHeaderView.h"

// Framework
#import <Masonry.h>

@interface HQLTableHeaderView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation HQLTableHeaderView

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

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_default_100x100"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _imageView;
}

#pragma mark - Private

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
    
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(20);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.bottom.mas_equalTo(self).with.offset(-20);
    }];
}

@end
