//
//  FoxInfiniteCollectionViewDataSourceProxy.m
//  FoxEssProject
//
//  Created by huqilin on 2025/2/17.
//

#import "FoxInfiniteCollectionViewDataSourceProxy.h"
#import "FoxInfiniteCollectionViewFlowLayout.h"

@implementation FoxInfiniteCollectionViewDataSourceProxy

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    FoxInfiniteCollectionViewFlowLayout *infiniteLayout = (FoxInfiniteCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    NSInteger numberOfItems = [self numberOfItemsInCollectionView:collectionView];
    NSInteger totalNumber = infiniteLayout.leftPaddedCount + infiniteLayout.rightPaddedCount + numberOfItems;
    return  totalNumber;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FoxInfiniteCollectionViewFlowLayout *infiniteLayout = (FoxInfiniteCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    NSInteger numberOfItems = [self numberOfItemsInCollectionView:collectionView];
    NSInteger itemIndex = (indexPath.row - infiniteLayout.leftPaddedCount < 0) ?
    ((indexPath.row - infiniteLayout.leftPaddedCount)%numberOfItems + numberOfItems)%(numberOfItems) :
    (indexPath.row - infiniteLayout.leftPaddedCount)%(numberOfItems);
    NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForItem:itemIndex inSection:indexPath.section];
    // This method must always return a valid view object.
    NSAssert([self.actualDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)], @"data source must implement this method.");
    return [self.actualDataSource collectionView:collectionView cellForItemAtIndexPath:adjustedIndexPath];
}

- (NSInteger)numberOfItemsInCollectionView:(UICollectionView *)collectionView {
    return ([self.actualDataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)] ?
            [self.actualDataSource collectionView:collectionView numberOfItemsInSection:0] : 0);
}

@end
