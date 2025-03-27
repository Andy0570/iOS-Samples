//
//  HQLCustomSlider.m
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/27.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import "HQLCustomSlider.h"

@implementation HQLCustomSlider

/// 设置 track（滑条）尺寸
- (CGRect)trackRectForBounds:(CGRect)bounds {
    // 方案一，参考：<https://medium.com/ios-os-x-development/how-to-personalize-and-use-uislider-in-swift-ec96d2e8f99d>
    // return CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds), bounds.size.width, 10);
    
    // 方案二，参考：<https://medium.com/doyeona/customize-uislider-and-uiprogressview-fe5fe73f2dd2>
    CGRect rect = [super trackRectForBounds: bounds];
    rect.origin.x = 0;
    rect.size.width = bounds.size.width;
    rect.size.height = 10; // added height for desired effect
    return rect;
}

/// 设置 thumb（滑块）尺寸
// - (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value;

@end
