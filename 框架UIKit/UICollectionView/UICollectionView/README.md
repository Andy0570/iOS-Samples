# CollectionViewDemo

iOS  `UICollectionView`  集合视图使用示例。



### UICollectionViewFlowLayout 集合视图的布局属性概述

以下是 `UICollectionViewFlowLayout.h` 文件中声明的属性：

```objective-c
UIKIT_EXTERN API_AVAILABLE(ios(6.0)) @interface UICollectionViewFlowLayout : UICollectionViewLayout

// 集合元素行与行之间的最小距离 (垂直间的距离)
@property (nonatomic) CGFloat minimumLineSpacing;
// 集合元素列与列之间的最小距离（水平之间距离）
@property (nonatomic) CGFloat minimumInteritemSpacing;
// 每个集合元素的大小
@property (nonatomic) CGSize itemSize;
/**
 设置每个集合的估计大小，默认为 CGSizeZero
 
 如果你设置了一个非 CGSizeZero 值的尺寸，系统会自动通过 preferredLayoutAttributesFittingAttributes:
 属性调整集合元素的尺寸
 */
@property (nonatomic) CGSize estimatedItemSize API_AVAILABLE(ios(8.0));
/**
 设置集合元素的滚动方向
 
 该值是一个枚举类型：
  * UICollectionViewScrollDirectionVertical 垂直滚动，默认值
  * UICollectionViewScrollDirectionHorizontal 水平滚动
 */
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
// 设置头视图（页眉视图）尺寸大小
@property (nonatomic) CGSize headerReferenceSize;
// 设置尾视图（页脚视图）尺寸大小
@property (nonatomic) CGSize footerReferenceSize;
/* 
 设置每个 Section 的 UIEdgeInsets
 
 此属性设置的是整组 section 的上左下右的冗余插入量
 注：设置这个属性不会把 item 变小或者变大
 */
@property (nonatomic) UIEdgeInsets sectionInset;

/// The reference boundary that the section insets will be defined as relative to. Defaults to `.fromContentInset`.
/// NOTE: Content inset will always be respected at a minimum. For example, if the sectionInsetReference equals `.fromSafeArea`, but the adjusted content inset is greater that the combination of the safe area and section insets, then section content will be aligned with the content inset instead.
@property (nonatomic) UICollectionViewFlowLayoutSectionInsetReference sectionInsetReference API_AVAILABLE(ios(11.0), tvos(11.0)) API_UNAVAILABLE(watchos);

// 下面这两个方法用于设置分区的页眉视图和页脚视图是否始终固定在屏幕顶部和底部（类似于 UITableView）
@property (nonatomic) BOOL sectionHeadersPinToVisibleBounds API_AVAILABLE(ios(9.0));
@property (nonatomic) BOOL sectionFootersPinToVisibleBounds API_AVAILABLE(ios(9.0));

@end
```



### UICollectionViewDelegateFlowLayout 协议概述

```objective-c
 @protocol UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>
 @optional
 
 // 集合元素大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
 
 // 集合元素的边缘插入量
 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
 
 // 最小行距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
 
 // 最小列距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
 
 // 表头视图大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
 
 // 表尾视图大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
 
 @end
```



### UICollectionViewDataSourcePrefetching 协议

```objective-c
@protocol UICollectionViewDataSourcePrefetching <NSObject>
@required
// indexPaths are ordered ascending by geometric distance from the collection view
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths API_AVAILABLE(ios(10.0));

@optional
// indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -collectionView:prefetchItemsAtIndexPaths:
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths  API_AVAILABLE(ios(10.0));

@end
```

