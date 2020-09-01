//
//  CollectionReusableView.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化 label，设置文字颜色，最后添加 label 到重用视图
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.bounds.size.width-40, self.bounds.size.height)];
        _label.textColor = [UIColor blackColor];
        [self addSubview:_label];
    }
    return self;
}

@end
