//
//  WaterFlowCollectionViewLayout.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/24.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "WaterFlowCollectionViewLayout.h"

// 默认列数
static const NSInteger KDefaultNumberOfColumn = 3;
// 每一列之间的距离
static const CGFloat KDefaultColumnMargin = 10;
// 每一行之间的距离
static const CGFloat KDefaultRowMargin = 10;
// section 边缘插入量
static const UIEdgeInsets KDefaultSectionInsert = {20, 20, 20, 20};


@interface WaterFlowCollectionViewLayout ()

// 缓存所有 cell 的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;
// 缓存所有列的当前累积高度
@property (nonatomic, strong) NSMutableArray *columHeights;
// 缓存内容的最大高度，用来计算并设置方法： collectionViewContentSize 的返回尺寸值
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation WaterFlowCollectionViewLayout

#pragma mark - Custom Accessors

// 列数
- (NSInteger)numberOfColumn {
    if ([self.delegate respondsToSelector:@selector(numberOfColumInWaterFlowLayout:)]) {
        return [self.delegate numberOfColumInWaterFlowLayout:self];
    }else {
        return KDefaultNumberOfColumn;
    }
}

// 每一行之间的距离
- (CGFloat)rowMargin {
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    }else {
        return KDefaultRowMargin;
    }
}

// 每一列之间的距离
- (CGFloat)columnMargin {
    if ([self.delegate respondsToSelector:@selector(columMarginInWaterFlowLayout:)]) {
        return [self.delegate columMarginInWaterFlowLayout:self];
    }else {
        return KDefaultColumnMargin;
    }
}

// 边缘插入量
- (UIEdgeInsets)sectionInset {
    if ([self.delegate respondsToSelector:@selector(sectionInsetInWaterFlow:)]) {
        return [self.delegate sectionInsetInWaterFlow:self];
    }else {
        return KDefaultSectionInsert;
    }
}

- (NSMutableArray *)columHeights {
    if (!_columHeights) {
        _columHeights = [NSMutableArray array];
    }
    return _columHeights;
}

- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - Override

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout {
    [super prepareLayout];
    
    // 【预缓存】
    // 1.重置最大高度
    self.contentHeight = 0;
    
    // 2.重置所有当前列的高度
    [self.columHeights removeAllObjects];
    for (NSInteger i = 0; i < self.numberOfColumn; i++) {
        [self.columHeights addObject:@(self.sectionInset.top)];
    }
    
    // 3.重置所有的布局属性
    [self.attrsArray removeAllObjects];
    // 开始创建每一个cell对应的布局
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 获取 Item 对应的位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取 indexPath 位置 cell 对应的布局属性,
        // 💡 这里调用的获取位置的方法（layoutAttributesForItemAtIndexPath:）是子类实现的
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

// return an array layout attributes instances for all the views in the given rect
// 返回给定rect中所有实例视图的布局属性数组
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

// 返回一个指定索引视图的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建布局属性
    // 获取 indexPath 位置 cell 对应的布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat widthOfCollectionView = self.collectionView.frame.size.width;
    
    // 1.计算宽高值
    // Item 的宽度 = （屏幕宽度-Section左右插入量-每个Item的水平Margin间隙） / Item个数
    CGFloat width = (widthOfCollectionView - self.sectionInset.left - self.sectionInset.right - (self.numberOfColumn - 1) * self.columnMargin) / self.numberOfColumn;
    CGFloat height = [self.delegate heightForItemInWaterFlowLayout:self
                                                      widthForItem:width
                                                       atIndexPath:indexPath.item];
    
    // 找出高度最短的那一列
    NSInteger shortestItemIndex = 0; // 高度最短 Item 的 index 索引
    CGFloat minColumnHeight = [self.columHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.numberOfColumn; i ++) {
        // 取得第 i 列的高度
        CGFloat height = [self.columHeights[i] doubleValue];
        
        if (minColumnHeight > height) {
            minColumnHeight = height;
            shortestItemIndex = i;
        }
    }
    
    // 2.计算 X，Y 值
    CGFloat x = self.sectionInset.left + shortestItemIndex * (width + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.sectionInset.top) {
        y += self.rowMargin;
    }
    
    // 3.设置布局属性的frame
    attrs.frame = CGRectMake(x, y, width, height);
    
    // 更新最短那列的高度
    self.columHeights[shortestItemIndex] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的最大高度（集合中元素高度的累积值，最大值）
    CGFloat columnHeight = [self.columHeights[shortestItemIndex] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

// Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.这些值表示所有内容的宽度和高度，而不仅仅是当前可见内容。 集合视图使用此信息来配置其自己的内容大小以方便滚动。
// 配置整个集合视图内容的（宽，高）以方便滚动（类似于配置UIScrollView 的 contentSize）。
// 此处如果返回默认值 CGSizero，集合视图就会无法滚动。
- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.contentHeight + self.sectionInset.bottom);
}


@end
