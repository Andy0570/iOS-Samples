//
//  HQLBrandItemCell.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/15.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQLBrandModel;

NS_ASSUME_NONNULL_BEGIN

/**
 商品品牌 - 品牌 cell
 
 视图元素：图片+标题，上下布局
 */
@interface HQLBrandItemCell : UICollectionViewCell

@property (nonatomic, strong) HQLBrandModel *brandModel;

@end

NS_ASSUME_NONNULL_END
