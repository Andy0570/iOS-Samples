//
//  CustomCollectionViewFlowLayout.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/25.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

@implementation CustomCollectionViewFlowLayout

#pragma mark - Override

- (void)prepareLayout {
    [super prepareLayout];
    
    // 设置 Section 边缘插入量
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

// 返回给定区域中所有实例视图的布局属性数组
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 获得 super 已经计算好的布局属性
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    // 计算 collectionView 中心点的 X 值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 💡 在原有布局的基础上进行微调
    for (UICollectionViewLayoutAttributes *attrs in attributes) {
        // cell 的中心点 x 和 collectionView 最中心点的距离
        // ABS() 函数：计算整数的绝对值
        CGFloat distance = ABS(attrs.center.x - centerX);
        // 根据间距值计算 cell 的缩放比例，
        // 分母不变，间距值越大，分子越大，缩放比例就会越大
        CGFloat scale = 1 - distance / self.collectionView.frame.size.width;
        // 根据偏移量调整缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return attributes;
}

// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
// collectionView 停止滚动后，重新设置偏移量
// 默认情况下，手指移到哪，视图就自然停在哪里，而我们需要的是手指停止拖动后，视图正好显示一个完整视图（类似于page页面一样）
// 返回值是：视图可见内容的左上角
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.x = proposedContentOffset.x; // 实际的建议的内容偏移量
    rect.origin.y = 0;
    rect.size = self.collectionView.frame.size;
    // 获得 super 已经计算好的、指定区域内所有矩形框的布局属性
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    // 计算 collectionView 最中心点的值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2;
    // 💡原理：计算哪个集合元素距离中心点位置最近，就设置哪个集合元素作为主视图。
    // 存放最小的间距值
    CGFloat minDistance = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in attributes) {
        if (ABS(minDistance) > ABS(attrs.center.x - centerX)) {
            minDistance = attrs.center.x - centerX;
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minDistance;
    return proposedContentOffset;
}

// return YES to cause the collection view to requery the layout for geometry information
// 判定为布局需要被无效化并重新计算的时候，布局对象会被询问以提供新的布局。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
