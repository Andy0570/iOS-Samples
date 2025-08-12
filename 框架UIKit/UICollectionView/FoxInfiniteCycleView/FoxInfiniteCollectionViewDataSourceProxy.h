//
//  FoxInfiniteCollectionViewDataSourceProxy.h
//  FoxEssProject
//
//  Created by huqilin on 2025/2/17.
//

#import <UIKit/UIKit.h>
@class FoxInfiniteCollectionViewFlowLayout;

NS_ASSUME_NONNULL_BEGIN

@interface FoxInfiniteCollectionViewDataSourceProxy : NSObject <UICollectionViewDataSource>

/**
 The actual data source of the collection view.
 */
@property (nonatomic, weak) id<UICollectionViewDataSource> actualDataSource;

@end

NS_ASSUME_NONNULL_END
