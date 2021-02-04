//
//  WaterFlowCollectionViewLayout.m
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/24.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import "WaterFlowCollectionViewLayout.h"


/**
 默认值
 
 下面的四个参数是 Protocol 中的可选方法所需的参数，
 如果遵守 <WaterFlowCollectionViewDelegate> 协议的对象实现了可选方法并返回了自定义参数，则使用自定义参数，否则就使用以下的默认参数。
 */
// 默认的列数
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

/**
缓存所有列的当前累积高度

作用：
你把瀑布流布局想象成玩「俄罗斯方块」游戏，系统布局添加 Item 时，需要在最短的那一列往下叠加。
因此，我们需要知道：当前视图页面上那么多列瀑布流中，哪一列是最短的？
因此，这个数组的作用就是缓存所有当前列累积的高度，后面用来判断到底谁最短！！！
*/
@property (nonatomic, strong) NSMutableArray *columHeights;

/**
 缓存内容的最大高度
 
 作用：
 用来计算并设置方法 collectionViewContentSize 的返回尺寸值
 */
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

// 缓存所有列的当前累积高度
- (NSMutableArray *)columHeights {
    if (!_columHeights) {
        _columHeights = [NSMutableArray array];
    }
    return _columHeights;
}

// 缓存所有 cell 的布局属性
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
    // 开始创建每一个 cell 对应的布局
    // 获取一组集合中的元素数量
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    // 遍历每一个 item，获取并缓存布局属性
    for (NSInteger i = 0; i < count; i++) {
        // 获取 Item 对应的位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取 indexPath 位置 cell 对应的布局属性,
        // 💡 这里调用的获取位置的方法（layoutAttributesForItemAtIndexPath:）是子类实现的 1⃣️
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

// return an array layout attributes instances for all the views in the given rect
// 返回给定区域中所有实例视图的布局属性数组
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

// 💡 返回指定元素的布局属性 1⃣️
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 创建布局属性
    // 获取 indexPath 位置 cell 对应的布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 集合视图的宽度 = 屏幕宽度
    CGFloat widthOfCollectionView = self.collectionView.frame.size.width;
    
    // 1.计算宽高值
    // Item 的宽度 = （屏幕宽度 - Section左右插入量 - 每个Item的水平Margin间隙） / Item个数
    // 💡 优化点，宽高值通过 YYKit 中的「像素对齐方函数」设置成整数，可以防止 GPU 离屏渲染 UI
    CGFloat width = (widthOfCollectionView - self.sectionInset.left - self.sectionInset.right - (self.numberOfColumn - 1) * self.columnMargin) / self.numberOfColumn;
    /**
     2⃣️ 高度由遵守 <WaterFlowCollectionViewDelegate> 协议的对象实现
     
     1. 任何 item 元素都有自己的宽高比例，给它一个实际宽度，计算并返回一个实际高度
     给这个对象传递一个我们已经计算好的宽度，然后按照实际 UI 的比例，计算等比例放大或者缩小后的视图的高度
     */
    CGFloat height = [self.delegate heightForItemInWaterFlowLayout:self
                                                      widthForItem:width
                                                       atIndexPath:indexPath.item];
    
    // 找出高度最短的那一列
    NSInteger shortestItemIndex = 0; // 默认值，高度最短 Item 的 index 索引
    // 💡 优化点：遍历算法可以使用基于 Block 的方式
    for (NSInteger i = 1; i < self.numberOfColumn; i ++) {
        // 取得第 i 列的高度
        CGFloat currentColumnHeight = [self.columHeights[i] doubleValue];
        
        if ([self.columHeights[shortestItemIndex] doubleValue] > currentColumnHeight) {
            // 缓存最短的列值
            shortestItemIndex = i;
        }
    }
    
    // 2.计算 X，Y 值（即 item 元素的起点坐标）
    CGFloat x = self.sectionInset.left + shortestItemIndex * (width + self.columnMargin);
    CGFloat y = [self.columHeights[shortestItemIndex] doubleValue];
    // 如果这里的 Y 值不是第一行，则要再添加一个边缘插入量的值
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

// Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.
// 这些值表示所有内容的宽度和高度，而不仅仅是当前可见内容。 集合视图使用此信息来配置其自己的内容大小以方便滚动。
// 配置整个集合视图内容的（宽，高）以方便滚动（类似于配置UIScrollView 的 contentSize）。
// 此处如果返回默认值 CGSizeZero，集合视图就会无法滚动。
- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.contentHeight + self.sectionInset.bottom);
}


@end
