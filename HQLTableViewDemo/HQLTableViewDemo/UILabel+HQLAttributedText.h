//
//  UILabel+HQLAttributedText.h
//  SeaTao
//
//  Created by Qilin Hu on 2020/7/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 设置属性字符串文本
@interface UILabel (HQLAttributedText)

/// 带删除线的商品原价
/// @param price 商品原价
- (void)hql_setAttributedTextWithOriginalPrice:(float)price;

/// ¥ %.2f
/// 效果：整体红色字体，"¥" #14 号字体，"￥%.0f" #20 号字体，
/// @param price 商品价格
- (void)hql_setAttributedTextWithProductPrice:(float)price;

/// ¥ %.2f
/// @param price 商品价格
/// @param smallFontSize "¥" 字体大小
/// @param bigFontSize "￥%.0f" 字体大小
- (void)hql_setAttributedTextWithProductPrice:(float)price
                              smallFontOfSize:(CGFloat)smallFontSize
                                bigFontOfSize:(CGFloat)bigFontSize;

/// 合计：￥%.0f
/// 效果："合计："灰色字体，"￥%.0f" 红色字体
/// @param totalPrice 合计金额
- (void)hql_setAttributedTextWithTotalPrice:(float)totalPrice;

/// 共 n 件商品
/// 效果：商品数量带下划线
/// @param amount 商品数量
- (void)hql_setAttributedTextWithProductAmount:(NSInteger)amount;


/// 已优惠：-¥ %.2f
/// 效果："已优惠：" 灰色字体，"-¥ %.2f" 红色字体
/// @param promotionAmount 已优惠金额
- (void)hql_setAttributedTextWithPromotionAmount:(float)promotionAmount;

@end

NS_ASSUME_NONNULL_END
