//
//  HQLSharePannelView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/3/22.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLSharePannelViewHeight;

@protocol HQLSharePannelViewDelegate <NSObject>
@required
- (void)selectedShareItemAtIndex:(NSInteger)index;
@end

@interface HQLSharePannelView : UICollectionViewCell

@property (nonatomic, weak) id<HQLSharePannelViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
