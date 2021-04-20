//
//  HQLStoreManagerModuleCell.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/30.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLStoreManagerModuleHeight;

@protocol HQLStoreManagerModuleDelegate <NSObject>
@required
- (void)selectStoreManagerItemAtIndex:(NSInteger)selectedIndex;
@end

/// MARK: 店长特权模块
@interface HQLStoreManagerModuleCell : UICollectionViewCell
@property (nonatomic, weak) id<HQLStoreManagerModuleDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
