//
//  UIImageExtras.h
//  ScaryBugs
//
//  Created by Ray Wenderlich on 8/23/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Extras)

// 对图片进行缩放的辅助方法
- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end

