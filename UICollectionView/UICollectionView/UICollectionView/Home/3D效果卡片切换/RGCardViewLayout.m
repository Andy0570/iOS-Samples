//
//  RGCardViewLayout.m
//  RGCardViewLayout
//
//  Created by ROBERA GELETA on 1/23/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import "RGCardViewLayout.h"

@implementation RGCardViewLayout
{
    NSIndexPath *mainIndexPath; // 当前 Item 索引
    NSIndexPath *movingInIndexPath; // 将要移入 Item 索引
    CGFloat difference;
    CGFloat previousOffset;
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self setupLayout];
}

// 初始化布局
- (void)setupLayout
{
    // 边缘插入量的左右边距
    CGFloat inset  = self.collectionView.bounds.size.width * (6/64.0f);
    inset = floor(inset); // 取不大于传入值的最大整数

    // 集合元素大小
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width - (2 *inset), self.collectionView.bounds.size.height * 3/4);
    // 集合元素的边缘插入量，左右添加边缘插入值
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    // 设置元素的滚动方向：水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

// 返回一个指定索引视图的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applyTransformToLayoutAttributes:attributes];
    
    return attributes;
}

// indicate that we want to redraw as we scroll
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 返回给定区域中所有实例视图的布局属性数组，给每个 Item 做个性化设置
// 屏幕滚动、布局页面的属性发生变化就会调用此方法
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获取父类（UICollectionViewFlowLayout）已经计算好的布局，在这个基础上进行修改
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    // 返回可见 Itme 的索引，实测个数在 1～2 之间
    NSArray *cellIndices = [self.collectionView indexPathsForVisibleItems];
    if(cellIndices.count == 0 ) // 0个可见 Item
    {
        return attributes;
    }
    else if (cellIndices.count == 1) // 1个可见 Item
    {
        mainIndexPath = cellIndices.firstObject;
        movingInIndexPath = nil;
    }
    else if(cellIndices.count > 1) // 2个可见 Item
    {
        // 区分左滑/右滑
        NSIndexPath *firstIndexPath = cellIndices.firstObject;
        if(firstIndexPath == mainIndexPath)
        {
            movingInIndexPath = cellIndices[1];
        }
        else
        {
            mainIndexPath = cellIndices[1];
            movingInIndexPath = cellIndices.firstObject;
        }
    }
    
    difference =  self.collectionView.contentOffset.x - previousOffset;
    previousOffset = self.collectionView.contentOffset.x;
    // 关键代码：取每一个 Itme 的布局属性，并添加 3D 效果
    for (UICollectionViewLayoutAttributes *attribute in attributes)
    {
        [self applyTransformToLayoutAttributes:attribute];
    }
    return  attributes;
}

- (void)applyTransformToLayoutAttributes:(UICollectionViewLayoutAttributes *)attribute
{
    if(attribute.indexPath.section == mainIndexPath.section) {
        // 当前 Item 索引
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:mainIndexPath];
        attribute.transform3D = [self transformFromView:cell];

    } else if (attribute.indexPath.section == movingInIndexPath.section) {
        // 将要移入的 Item 索引
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:movingInIndexPath];
        attribute.transform3D = [self transformFromView:cell];
    }
}


#pragma mark - Logica

- (CGFloat)baseOffsetForView:(UIView *)view
{
    UICollectionViewCell *cell = (UICollectionViewCell *)view;
    CGFloat offset =  ([self.collectionView indexPathForCell:cell].section) * self.collectionView.bounds.size.width;
    return offset;
}

// 视图的高度
- (CGFloat)heightOffsetForView:(UIView *)view
{
    CGFloat height;
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat scrollViewWidth = self.collectionView.bounds.size.width;
    //TODO: make this constant a certain proportion of the collection view
    height = ABS(120 * (currentOffset - baseOffsetForCurrentView)/scrollViewWidth);
    return height;
}

// 视图旋转的角度
- (CGFloat)angleForView:(UIView *)view
{
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat scrollViewWidth = self.collectionView.bounds.size.width;
    CGFloat angle = (currentOffset - baseOffsetForCurrentView)/scrollViewWidth;
    return angle;
}

// 计算旋转的方向
- (BOOL)xAxisForView:(UIView *)view
{
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat offset = (currentOffset - baseOffsetForCurrentView);

    return (offset >= 0) ? YES : NO;
}


#pragma mark - Transform Related Calculation

- (CATransform3D)transformFromView:(UIView *)view
{
    CGFloat angle = [self angleForView:view];
    CGFloat height = [self heightOffsetForView:view];
    BOOL xAxis = [self xAxisForView:view];
    return [self transformfromAngle:angle height:height xAxis:xAxis];
}

// 添加 3D 旋转
// FIXME: height 值未使用！存在转出视图有一个脚落还停留显示的Bug
- (CATransform3D)transformfromAngle:(CGFloat)angle height:(CGFloat)height xAxis:(BOOL)axis
{
    CATransform3D t = CATransform3DIdentity;
    t.m34  = - 1.0 / 500.0;
    
    // 3D旋转，一个正方向、一个反方向
    // CATransform3DRotate(CATransform3DIdentity, angle, x, y, z)
    if (axis) {
        t = CATransform3DRotate(t, angle, 1, 1, 0);
    }
    else {
        t = CATransform3DRotate(t, angle, -1, 1, 0);
    }
    
    return t;
}

@end

