//
//  AF26CollectionViewCell.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AF26CollectionViewCell.h"

@implementation AF26CollectionViewCell

#pragma mark - Initialize

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // MARK: 当 cell 为选中状态时，selectedBackgroundView 为白色
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.backgroundColor = [UIColor whiteColor];
    self.image = nil;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}

// MARK: 当 cell 高亮时，图片的 alpha 值为 0.8
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (self.highlighted) {
        self.imageView.alpha = 0.8f;
    } else {
        self.imageView.alpha = 1.0f;
    }
}

@end
