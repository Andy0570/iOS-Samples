//
//  HQLMineServiceItemCell.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/30.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMineServiceItemCell.h"
#import <Masonry.h>

const CGFloat HQLMineServiceItemHeight = 68.0f;

@implementation HQLMineServiceItemCell

- (void)layoutSubviews {
    
    // |-5-34-5-16-8-|
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).with.offset(5);
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).with.offset(5);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-8);
    }];
}

@end
