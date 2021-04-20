//
//  HQLMineServiceModuleCell.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/30.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLMineServiceModuleHeight;

@protocol HQLMineServiceModuleDelegate <NSObject>
@required
- (void)selectServiceItemAtIndex:(NSInteger)selectedIndex;
@end

/// MARK: 更多服务模块
@interface HQLMineServiceModuleCell : UICollectionViewCell
@property (nonatomic, weak) id<HQLMineServiceModuleDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
