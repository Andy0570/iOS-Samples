//
//  HQLMineServiceNameHeaderView.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/30.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLMineServiceNameHeaderViewHeight;

/**
 🥰 可复用模块，我的页面中，集合视图 header view
 
 视图元素：通过 UILabel 描述功能分组的标题
 */
@interface HQLMineServiceNameHeaderView : UICollectionReusableView
@property (nonatomic, copy, nullable) NSString *title;
@end

NS_ASSUME_NONNULL_END
