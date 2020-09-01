//
//  AFCollectionViewFlowLayout.h
//  Survey
//
//  Created by Ash Furrow on 2013-01-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMaxItemDimension   200.0f
#define kMaxItemSize        CGSizeMake(kMaxItemDimension, kMaxItemDimension)

extern NSString * const AFCollectionViewFlowLayoutBackgroundDecoration;

@interface AFCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
