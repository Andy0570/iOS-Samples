//
//  FoxInfiniteCollectionView.h
//  FoxEssProject
//
//  Created by huqilin on 2025/2/17.
//

#import <UIKit/UIKit.h>
#import "FoxInfiniteCollectionViewFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The collection view which can scroll infinitely.
 
 @note Even though the infinite scrolling capability is provided, some of the collection
 view's functionalities are sacrificed.
 1. Notably, the collection view will only have one section of items and section titles are disabled.
 2. All the collection view cells are centered vertically in the collection view;
 */
@interface FoxInfiniteCollectionView : UICollectionView

/**
 Override the disignated intializer;

 @param frame The collection view's frame.
 @param layout An instance of FoxInfiniteCollectionViewFlowLayout.
 @return Constructed collection view.
 */
- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(FoxInfiniteCollectionViewFlowLayout *)layout NS_DESIGNATED_INITIALIZER;

/**
 Using FoxInfiniteCollectionView with xib is currently not supported.
 */
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
