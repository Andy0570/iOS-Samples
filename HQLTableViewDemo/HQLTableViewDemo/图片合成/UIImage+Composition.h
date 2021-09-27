//
//  UIImage+Composition.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/18.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Composition)

// 直接合成图片
+ (UIImage *)compositionWithBackImage:(UIImage *)backImage
                           frontImage:(UIImage *)frontImage;

// 使用 CoreGraphics 框架合成图片
+ (UIImage *)compositionCoreGraphicsWithBackImage:(UIImage *)backImage
                                       frontImage:(UIImage *)frontImage;

// 使用 CoreImage 框架以添加滤镜的形式合成图片
- (UIImage *)compositionCoreImageWithBackImage:(UIImage *)backImage
                                    frontImage:(UIImage *)frontImage;

// 生成自定义的 pattern 图案
- (UIImage *)compositionPatternWithBackImage:(CGSize *)containerSize
                                       image:(UIImage *)frontImage;

// 使用第三方 GPUImage 框架
- (UIImage *)processUsingGPUImage:(UIImage *)backImage frontImage:(UIImage *)frontImage;

@end

NS_ASSUME_NONNULL_END
