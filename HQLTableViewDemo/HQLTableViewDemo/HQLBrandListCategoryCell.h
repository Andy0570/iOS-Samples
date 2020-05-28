//
//  HQLBrandListCategoryCell.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/15.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN const CGFloat HQLBrandListCategoryCellHeight;

/**
 商品品类 - 左侧品类标题
 */
@interface HQLBrandListCategoryCell : UITableViewCell

@property (nonatomic, copy) NSString *name; // 品类名称

@end

NS_ASSUME_NONNULL_END
