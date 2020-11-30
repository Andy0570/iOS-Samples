//
//  UILabel+ChangeRightAndLeftAlignment.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "UILabel+ChangeRightAndLeftAlignment.h"
#import <CoreText/CoreText.h>

@implementation UILabel (ChangeRightAndLeftAlignment)

- (void)hql_changeRightAndLeftAlignment:(CGFloat)labelWidth stringLength:(NSUInteger)length {
    // 计算文本宽度
    CGSize testSize = [self.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :self.font} context:nil].size;
    
    // 文本之间的距离 = （Label的宽度 - 文本宽度）/ （文字个数 - 1）
    CGFloat margin = (labelWidth - testSize.width)/length;
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    // 字间距 :NSKernAttributeName
    [attribute addAttribute: NSKernAttributeName value:number range:NSMakeRange(0, length)];
    self.attributedText = attribute;
}

- (void)hql_changeRightAndLeftAlignment:(CGFloat)labelWidth {
    [self hql_changeRightAndLeftAlignment:labelWidth stringLength:self.text.length - 1];
}

// 如果标题带冒号: 那么【最后一个字】和【冒号】之间不应有空格
- (void)hql_changeRightAndLeftAlignmentWithDot:(CGFloat)labelWidth {
    [self hql_changeRightAndLeftAlignment:labelWidth stringLength:self.text.length - 2];
}

@end
