//
//  FoxInfiniteCollectionViewFlowLayout.m
//  FoxEssProject
//
//  Created by huqilin on 2025/2/17.
//

#import "FoxInfiniteCollectionViewFlowLayout.h"
#import "FoxInfiniteCollectionView.h"
#import <objc/runtime.h>

@interface FoxInfiniteCollectionViewFlowLayout ()
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *layoutAttribsMap;
@property (nonatomic, assign) CGFloat acturalItemSpacing;
@end

@implementation FoxInfiniteCollectionViewFlowLayout
@synthesize dataSourceProxy = _dataSourceProxy;

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemSize = CGSizeMake(50.0f, 50.0f);
        _acturalItemSpacing = 0.f;
        _leftPaddedCount = 0;
        _rightPaddedCount = 0;
        FoxInfiniteCollectionItemsSpan actualItemsSpan;
        actualItemsSpan.minContentOffset = 0.f;
        actualItemsSpan.maxContentOffset = 0.f;
        _acturalItemsSpan = actualItemsSpan;
        _infinite = YES;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // does collection has size
    if (CGRectIsEmpty(self.collectionView.bounds) ||
        !self.itemSize.width || !self.itemSize.height) {
        NSLog(@"Collection view bounds empty || itemSize empty; no need to calculate layout.");
        return;
    }
    
    // pad extra items both start and end
    [self padExtraItems];
    NSInteger itemsCount = [self itemsCount];
    if (!itemsCount) {
        return;
    }
    
    // calculate item attributes;
    _layoutAttribsMap = [NSMutableDictionary dictionaryWithCapacity:itemsCount];
    for (NSInteger item = 0; item < itemsCount; item++) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        itemAttributes.frame = [self frameForAttributeAtIndexPath:itemIndexPath];
        if (itemAttributes) {
            [_layoutAttribsMap setObject:itemAttributes forKey:itemIndexPath];
        }
    }
    
    // The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
    // set content offset
    CGFloat startOffsetX = _leftPaddedCount * (self.itemSize.width + self.acturalItemSpacing);
    self.collectionView.contentOffset = CGPointMake(startOffsetX, 0);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<UICollectionViewLayoutAttributes *> *layoutAttributes = self.layoutAttribsMap.allValues;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:layoutAttributes.count];
    for (UICollectionViewLayoutAttributes *itemAttributes in layoutAttributes) {
        if (CGRectIntersectsRect(itemAttributes.frame, rect)) {
            [array addObject:itemAttributes];
        }
    }
    return array;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttribsMap[indexPath];
}

- (CGSize)collectionViewContentSize {
    NSInteger itemsCount = [self itemsCount];
    return CGSizeMake(itemsCount * (self.itemSize.width + self.acturalItemSpacing), self.collectionView.bounds.size.height);
}

#pragma mark - Private

- (NSInteger)itemsCount {
    NSInteger sectionCount = [self.collectionView numberOfSections];
    if (!sectionCount) {
        return 0;
    }
    NSAssert(sectionCount == 1, @"only one section is allowed.");
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];
    return itemsCount;
}

- (CGRect)frameForAttributeAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemY = (self.collectionView.bounds.size.height - self.itemSize.height) * 0.5;
    CGFloat itemX = (self.itemSize.width + self.acturalItemSpacing) * indexPath.item;
    return CGRectMake(itemX, itemY, self.itemSize.width, self.itemSize.height);
}

- (void)padExtraItems {
    NSInteger originalCount = ([self.dataSourceProxy.actualDataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) ?
    [self.dataSourceProxy.actualDataSource collectionView:self.collectionView numberOfItemsInSection:0] : 0;
    if (!originalCount) {
        return;
    }
    
    // calculate actual spacing
    CGFloat itemWidth = self.itemSize.width;
    CGFloat minItemSpacing = self.minimumInteritemSpacing;
    CGFloat collectionWidth = self.collectionView.bounds.size.width;
    
    NSInteger maxItemCount = floor((collectionWidth + minItemSpacing) / (itemWidth + minItemSpacing));
    CGFloat actualItemSpacing = (maxItemCount <= 1) ? minItemSpacing : (collectionWidth - maxItemCount * itemWidth) / (maxItemCount - 1);
    
    _acturalItemSpacing = actualItemSpacing;
    CGFloat itemSpan = originalCount * (actualItemSpacing + itemWidth) - actualItemSpacing;
    
    /*
     The goal here is try to have at leat THREE pages of items (WITH a few duplicates).
     - If the itemSpan is bigger than collectionWidth, theoretically, only one page of duplicate
     at both the left and right end wount do the trick.
     - If the itemSpan is less than collectionWidth, we will have a bit more than
     three pages of items;
     */
    if (self.isInfinite) {
        if (itemSpan > collectionWidth) {
            NSInteger onePageCount = ceil((collectionWidth + itemWidth) / (actualItemSpacing + itemWidth));
            _leftPaddedCount = onePageCount;
            _rightPaddedCount = _leftPaddedCount;
        }
        else {
            NSInteger itemsTotal = ceil((3 * collectionWidth + itemWidth)/(actualItemSpacing + itemWidth));
            NSInteger itemsPadded = itemsTotal - originalCount;
            _leftPaddedCount = ceil((1 * collectionWidth + itemWidth)/(actualItemSpacing + itemWidth));
            _rightPaddedCount = itemsPadded - _leftPaddedCount;
        }
    }
    else {
        _leftPaddedCount = 0;
        _rightPaddedCount = 0;
    }
    
    // actural items span
    _acturalItemsSpan.minContentOffset = _leftPaddedCount * (itemWidth + actualItemSpacing);
    _acturalItemsSpan.maxContentOffset = (_leftPaddedCount + originalCount) * (itemWidth + actualItemSpacing) - actualItemSpacing;
}

#pragma mark - Lazy Loading

- (FoxInfiniteCollectionViewDataSourceProxy *)dataSourceProxy {
    if (!_dataSourceProxy) {
        _dataSourceProxy = [[FoxInfiniteCollectionViewDataSourceProxy alloc] init];
    }
    return _dataSourceProxy;
}

@end

@implementation FoxInfiniteCollectionViewFlowLayout (FoxPrivate)
- (void)resetContentOffsetIfNeededForCollectionView:(UICollectionView *)collectionView {
    // return if infinite scrolling is now wanted.
    if (!self.isInfinite) {
        return;
    }
    
    // reset the content offset
    CGFloat collectionWidth = collectionView.bounds.size.width;
    CGPoint currentOffset = collectionView.contentOffset;
    CGFloat spanWidth = self.acturalItemsSpan.maxContentOffset - self.acturalItemsSpan.minContentOffset;
    if (collectionView.contentOffset.x < self.acturalItemsSpan.minContentOffset - collectionWidth) {
        collectionView.contentOffset = CGPointMake(spanWidth + self.acturalItemSpacing + currentOffset.x, currentOffset.y);
    } else if (collectionView.contentOffset.x > self.acturalItemsSpan.maxContentOffset) {
        collectionView.contentOffset = CGPointMake(currentOffset.x - spanWidth - self.acturalItemSpacing, currentOffset.y);
    }
}
@end
