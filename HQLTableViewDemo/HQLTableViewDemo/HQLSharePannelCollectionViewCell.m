//
//  HQLSharePannelCollectionViewCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/3/22.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLSharePannelCollectionViewCell.h"
#import <Masonry.h>

const CGFloat HQLSharePannelCollectionViewCellHeight = 80.f;

@implementation HQLSharePannelCollectionViewCell

- (void)layoutSubviews {
    // |-5-50-5-15-5-|
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(5);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

@end
