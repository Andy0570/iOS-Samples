//
//  HQLMineCollectionViewFlowLayout.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/1.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMineCollectionViewFlowLayout.h"

@implementation HQLMineCollectionViewFlowLayout


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

 // 返回给定区域中所有实例视图的布局属性数组
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    UICollectionView *collectionView = [self collectionView];
    UIEdgeInsets insets = [collectionView contentInset];
    CGPoint offset = [collectionView contentOffset];
    CGFloat minY = -insets.top;

    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    if (offset.y < minY) {

        CGSize  headerSize = [self headerReferenceSize];
        CGFloat deltaY = ABS(offset.y - minY);

        for (UICollectionViewLayoutAttributes *attrs in attributes) {

            if ([attrs representedElementKind] == UICollectionElementKindSectionHeader) {

                CGRect headerRect = [attrs frame];
                headerRect.size.height = MAX(minY, headerSize.height + deltaY);
                headerRect.origin.y = headerRect.origin.y - deltaY;
                [attrs setFrame:headerRect];
                break;
            }
        }
    }

    return attributes;
}

@end
