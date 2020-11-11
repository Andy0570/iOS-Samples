//
//  PANumberLabel.h
//  XuZhouSS
//
//  Created by Qilin Hu on 2018/3/27.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 步骤文本标签，显示1234
 */
@interface PANumberLabel : UILabel

// 是否高亮文本
@property (nonatomic, assign) BOOL isHighlight;

- (instancetype)initWithFrame:(CGRect)frame number:(int)iNumber;

@end
