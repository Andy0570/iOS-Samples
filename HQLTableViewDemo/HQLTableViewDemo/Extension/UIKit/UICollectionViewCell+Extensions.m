//
//  UICollectionViewCell+Extensions.m
//  SeaTao
//
//  Created by Qilin Hu on 2021/1/21.
//  Copyright © 2021 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "UICollectionViewCell+Extensions.h"

@implementation UICollectionViewCell (Extensions)

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    if (selectedBackgroundColor) {
        UIView *selectBGView = [[UIView alloc] init];
        selectBGView.backgroundColor = selectedBackgroundColor;
        self.selectedBackgroundView = selectBGView;
    } else {
        self.selectedBackgroundView = nil;
    }
}

- (UIColor *)selectedBackgroundColor {
    return self.selectedBackgroundView.backgroundColor;
}

@end
