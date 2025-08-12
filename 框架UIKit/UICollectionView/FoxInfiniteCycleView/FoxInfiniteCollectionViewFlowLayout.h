//
//  FoxInfiniteCollectionViewFlowLayout.h
//  FoxEssProject
//
//  Created by huqilin on 2025/2/17.
//

#import <UIKit/UIKit.h>
#import "FoxInfiniteCollectionViewDataSourceProxy.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FoxInfiniteCollectionViewItemsLayoutDirection) {
    FoxInfiniteCollectionViewItemsLayoutDirectionHorizontal,
    FoxInfiniteCollectionViewItemsLayoutDirectionVertical,
};

/**
 Used to describe how wide the cell items are laid out in one direction.
 */
struct FoxInfiniteCollectionItemsSpan {
    CGFloat minContentOffset;
    CGFloat maxContentOffset;
};
typedef struct FoxInfiniteCollectionItemsSpan FoxInfiniteCollectionItemsSpan;

/**
 FoxInfiniteCollectionViewFlowLayout only supports a single line of items.
 Currently, only horizontal scrolling is supported.
 */
@interface FoxInfiniteCollectionViewFlowLayout : UICollectionViewLayout

/**
 The infinite collection view's data source proxy. This is needed to add a layer
 of indirection for the collection view's data source. Because of this layer of
 indirection, the infinite collection view's actual data source will not be aware
 of any inner implementation details of infinite scolling.
 */
@property (nonatomic, strong, readonly) FoxInfiniteCollectionViewDataSourceProxy *dataSourceProxy;

/**
 How many extra items are padded on the left side.
 */
@property (nonatomic, assign, readonly) NSInteger leftPaddedCount;

/**
 How many extra items are padded on the right side.
 */
@property (nonatomic, assign, readonly) NSInteger rightPaddedCount;

/**
 How the actual items (padded items excluded) are laid out in the collection view.
 */
@property (nonatomic, assign, readonly) FoxInfiniteCollectionItemsSpan acturalItemsSpan;

/**
 The size of each cell item.
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 The minimum spacing between two cell items. Since only one section is supported,
 the real item spacing used by the collection view is calculated and, in many cases,
 will be larger than the minimumInteritemSpacing set.
 */
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

/**
 The infinite switch flag to use.
 */
@property (nonatomic, assign, getter=isInfinite) BOOL infinite;

@end

@interface FoxInfiniteCollectionViewFlowLayout (FoxPrivate)

/**
 Reset the collection view's content offset to a scrollable area when the user scrolls
 to trigger the setting.
 
 @param collectionView The scrolling collection view.
 */
- (void)resetContentOffsetIfNeededForCollectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
