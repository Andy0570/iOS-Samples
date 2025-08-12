//
//  FoxInfiniteCollectionView.m
//  FoxEssProject
//
//  Created by huqilin on 2025/2/17.
//

#import "FoxInfiniteCollectionView.h"
#import "FoxInfiniteCollectionViewDataSourceProxy.h"

@interface FoxInfiniteCollectionView ()
@end

@implementation FoxInfiniteCollectionView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(FoxInfiniteCollectionViewFlowLayout *)layout {
    NSAssert([layout isKindOfClass:[FoxInfiniteCollectionViewFlowLayout class]],
             @"layout object must be of class FoxInfiniteCollectionViewFlowLayout");
    self = [super initWithFrame:frame collectionViewLayout:layout];
    return self;
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    FoxInfiniteCollectionViewFlowLayout *infiniteLayout = (FoxInfiniteCollectionViewFlowLayout *)self.collectionViewLayout;
    FoxInfiniteCollectionViewDataSourceProxy *dataSourceProxy = (dataSource) ? infiniteLayout.dataSourceProxy : nil;
    dataSourceProxy.actualDataSource = dataSource;
    [super setDataSource: dataSourceProxy];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    FoxInfiniteCollectionViewFlowLayout *infiniteLayout = (FoxInfiniteCollectionViewFlowLayout *)self.collectionViewLayout;
    [infiniteLayout resetContentOffsetIfNeededForCollectionView:self];
}

@end
