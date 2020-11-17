//
//  PANumberLabel.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
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
