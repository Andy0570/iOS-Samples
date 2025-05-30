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

#pragma mark - 商品原价

/// 带删除线的商品原价
/// @param price 商品原价
- (void)hql_setAttributedTextWithOriginalPrice:(float)price;

#pragma mark - 商品价格

/// ¥ %.2f
/// 效果：整体红色字体，"¥" #14 号字体，"￥%.0f" #20 号字体，
/// @param price 商品价格
- (void)hql_setAttributedTextWithProductPrice:(float)price;

/// ¥ %.2f，默认红色字体
/// @param price 商品价格
/// @param smallFontSize "¥" 人民币符号字体大小
/// @param bigFontSize "￥%.0f" 价格字符串字体大小
- (void)hql_setAttributedTextWithProductPrice:(float)price
                              smallFontOfSize:(CGFloat)smallFontSize
                                bigFontOfSize:(CGFloat)bigFontSize;

/// ¥ %.2f
/// @param price 商品价格
/// @param textColor 字体颜色
/// @param smallFontSize "¥" 人民币符号字体大小
/// @param bigFontSize "￥%.0f" 价格字符串字体大小
- (void)hql_setAttributedTextWithProductPrice:(float)price
                                    textColor:(UIColor *)textColor
                              smallFontOfSize:(CGFloat)smallFontSize
                                bigFontOfSize:(CGFloat)bigFontSize;

#pragma mark - 合计金额

/// 合计：￥%.0f
/// 效果："合计："灰色字体，"￥%.0f" 红色字体
/// @param totalPrice 合计金额
- (void)hql_setAttributedTextWithTotalPrice:(float)totalPrice;


/// 合计：￥%.0f
/// 效果："合计："12 #999999，"￥"12 #333333，"%.0f"12B #333333
/// @param calculateAmount 订单页面的合计金额
- (void)hql_setAttributedTextWithCalculateAmount:(float)calculateAmount;

#pragma mark - 共 n 件商品

/// 共 n 件商品
/// 效果：商品数量带下划线
/// @param amount 商品数量
- (void)hql_setAttributedTextWithProductAmount:(NSInteger)amount;

#pragma mark - 已优惠金额

/// 已优惠：-¥ %.2f
/// 效果："已优惠：" 灰色字体，"-¥ %.2f" 红色字体
/// @param promotionAmount 已优惠金额
- (void)hql_setAttributedTextWithPromotionAmount:(float)promotionAmount;

@end

NS_ASSUME_NONNULL_END
