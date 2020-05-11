//
//  HQLActivityDetailCell.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLActivityDetailCell.h"

@implementation HQLActivityDetailCell

#pragma mark - View life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化并添加图片视图
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        //_imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }
    return self;
}
@end
