//
//  AFCollectionViewFlowLayout.h
//  Dimensions
//
//  Created by Ash Furrow on 2013-01-13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFCollectionViewLayoutAttributes.h"

#define kMaxItemDimension   100
#define kMaxItemSize        CGSizeMake(kMaxItemDimension, kMaxItemDimension)

@protocol AFCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
@optional
-(AFCollectionViewFlowLayoutMode)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout layoutModeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface AFCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) AFCollectionViewFlowLayoutMode layoutMode;

@end
