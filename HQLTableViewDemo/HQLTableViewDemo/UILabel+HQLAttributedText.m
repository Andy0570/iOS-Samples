//
//  UILabel+HQLAttributedText.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/7/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "UILabel+HQLAttributedText.h"

@implementation UILabel (HQLAttributedText)

- (void)hql_setAttributedTextWithOriginalPrice:(float)price {
    NSAssert(price >= 0, @"商品原价应该大于等于零！");
    
    NSString *string = [NSString stringWithFormat:@"¥ %.2f",price];
    
    UIFont *textFont = [UIFont systemFontOfSize:11.0f];
    UIColor *textColor = UIColor.grayColor;
    NSDictionary *attributes = @{
        NSStrikethroughStyleAttributeName: @(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: textColor,
        NSFontAttributeName: textFont
    };
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    self.attributedText = attributedString;
}

- (void)hql_setAttributedTextWithProductPrice:(float)price {
    [self hql_setAttributedTextWithProductPrice:price smallFontOfSize:14.0f bigFontOfSize:20.0f];
}

- (void)hql_setAttributedTextWithProductPrice:(float)price
                              smallFontOfSize:(CGFloat)smallFontSize
                                bigFontOfSize:(CGFloat)bigFontSize
{
    NSAssert((price >= 0) && (smallFontSize > 0) && (bigFontSize > 0) &&
             (smallFontSize <= bigFontSize), @"参数断言异常！");
    
    NSString *string = [NSString stringWithFormat:@"¥ %.2f",price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    UIColor *redColor = UIColor.redColor;
    UIFont *smallFont = [UIFont systemFontOfSize:smallFontSize weight:UIFontWeightMedium];
    UIFont *bigFont = [UIFont systemFontOfSize:bigFontSize weight:UIFontWeightMedium];
    
    NSDictionary *attributes1 = @{
        NSForegroundColorAttributeName: redColor,
        NSFontAttributeName: smallFont
    };
    [attributedString addAttributes:attributes1 range:NSMakeRange(0, 1)];
    
    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName:redColor,
        NSFontAttributeName:bigFont
    };
    [attributedString addAttributes:attributes2 range:NSMakeRange(2, string.length - 2)];
    
    self.attributedText = attributedString;
}

- (void)hql_setAttributedTextWithTotalPrice:(float)totalPrice {
    NSAssert(totalPrice >= 0, @"合计金额应该大于等于零！");
    
    NSString *totalPriceString = [NSString stringWithFormat:@"￥%.0f", totalPrice];
    NSString *string = [NSString stringWithFormat:@"合计：%@", totalPriceString];
    
    UIFont *textFont = [UIFont systemFontOfSize:14];
    UIColor *grayTextColor = UIColor.grayColor;
    UIColor *redTextColor = UIColor.redColor;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributes1 = @{
        NSForegroundColorAttributeName: grayTextColor,
        NSFontAttributeName: textFont
    };
    [attributedString setAttributes:attributes1 range:NSMakeRange(0, 3)];
    
    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName: redTextColor,
        NSFontAttributeName: textFont
    };
    [attributedString setAttributes:attributes2 range:[string rangeOfString:totalPriceString]];
    
    self.attributedText = attributedString;
}

- (void)hql_setAttributedTextWithProductAmount:(NSInteger)amount {
    NSAssert(amount >= 0, @"商品数量应该大于等于零！");
    
    NSString *amountString = [NSString stringWithFormat:@"%ld", (long)amount];
    NSString *string = [NSString stringWithFormat:@"共 %@ 件商品", amountString];
    
    UIFont *textFont = [UIFont systemFontOfSize:14];
    UIColor *textColor = UIColor.grayColor;
    
    NSDictionary *defaultAttributes = @{
        NSForegroundColorAttributeName: textColor,
        NSFontAttributeName: textFont
    };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:defaultAttributes];

    NSDictionary *underlineAttributes = @{
        NSForegroundColorAttributeName: textColor,
        NSFontAttributeName: textFont,
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSUnderlineColorAttributeName: textColor
    };
    
    NSRange amountStringRange = NSMakeRange(2, amountString.length);
    [attributedString addAttributes:underlineAttributes range:amountStringRange];
    
    self.attributedText = attributedString;
}

- (void)hql_setAttributedTextWithPromotionAmount:(float)promotionAmount {
    NSAssert(promotionAmount >= 0, @"已优惠金额应该大于等于零！");
    
    NSString *promotionAmountText = [NSString stringWithFormat:@"-¥%.0f", promotionAmount];
    NSString *string = [NSString stringWithFormat:@"已优惠：%@",promotionAmountText];
    
    UIFont *textFont = [UIFont systemFontOfSize:11];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributes1 = @{
        NSForegroundColorAttributeName: UIColor.grayColor,
        NSFontAttributeName: textFont
    };
    [attributedString setAttributes:attributes1 range:NSMakeRange(0, 4)];
    
    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName: UIColor.redColor,
        NSFontAttributeName: textFont
    };
    [attributedString setAttributes:attributes2 range:[string rangeOfString:promotionAmountText]];
    
    self.attributedText = attributedString;
}

@end
