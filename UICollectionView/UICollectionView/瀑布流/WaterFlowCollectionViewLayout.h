//
//  WaterFlowCollectionViewLayout.h
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/24.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 布局类
 
 要创建自定义布局，需要创建一个继承自 UICollectionViewLayout/UICollectionViewFlowLayout 的子类。
 
 布局对象的主要工作是提供有关集合视图中项目的位置和视觉状态的信息。 布局对象不会为其提供布局创建视图。 这些视图是由集合视图的数据源创建的。相反，布局对象根据布局的设计来定义可视元素的位置和大小。
 
 每一个布局对象都需要实现以下的方法：
 // return an array layout attributes instances for all the views in the given rect
 // 返回给定区域中所有实例视图的布局属性数组
 - (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
 
 // 返回一个指定索引视图的布局属性
 - (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
 
 // 返回指定辅助视图的布局属性（如果有）
 - (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;
 
 // 返回指定装饰视图的布局属性。（如果有）
 - (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath;
 
 // 询问布局对象，如果 bounds 更新是否需要更新布局？
 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds; // return YES to cause the collection view to requery the layout for geometry information
 
 // 返回集合视图内容的宽和高(指的是所有集合视图元素组成的整体的尺寸)
 @property(nonatomic, readonly) CGSize collectionViewContentSize; // Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.
 #else
 - (CGSize)collectionViewContentSize; // Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.这些值表示所有内容的宽度和高度，而不仅仅是当前可见内容。 集合视图使用此信息来配置其自己的内容大小以方便滚动。
 
 */

@class WaterFlowCollectionViewLayout;

@protocol WaterFlowCollectionViewDelegate <NSObject>

@required
// 返回某一项的高度
- (CGFloat)heightForItemInWaterFlowLayout:(WaterFlowCollectionViewLayout *)waterFlowLayout widthForItem:(CGFloat)width atIndexPath:(NSUInteger)indexPath;

@optional
// 列数
- (NSInteger)numberOfColumInWaterFlowLayout:(WaterFlowCollectionViewLayout *)waterFlowLayout;
// 列间距，同一行集合元素之间的最小距离（水平距离）
- (CGFloat)columMarginInWaterFlowLayout:(WaterFlowCollectionViewLayout *)waterFlowLayout;
// 行间距，集合元素行与行之间的最小距离 (垂直距离)
- (CGFloat)rowMarginInWaterFlowLayout:(WaterFlowCollectionViewLayout *)waterFlowLayout;
// section 边缘插入量
- (UIEdgeInsets)sectionInsetInWaterFlow:(WaterFlowCollectionViewLayout *)waterFlowLayout;

@end


/**
 💡 瀑布流的核心思路
 
 之前两个 Demo 中的 UICollectionViewFlowLayout 实例的属性设置是静态的，因为每个元素的大小是固定且相同的。
 而瀑布流中每个元素的大小可能都不一样，因此需要通过 Delegate 的方式动态设置。
 需要根据每一个 Item 元素的大小去设置其 UICollectionViewLayoutAttributes 属性的 frame 属性。
 */
@interface WaterFlowCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterFlowCollectionViewDelegate> delegate;

@end

