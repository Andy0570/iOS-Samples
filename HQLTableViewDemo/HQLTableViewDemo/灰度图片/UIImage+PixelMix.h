//
//  UIImage+PixelMix.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/17.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 灰度图片转换算法类型
typedef NS_ENUM(NSUInteger, JKImageByGrayscaleType) {
    /**
     平均值算法
     灰度计算公式：Gray = (Red + Green + Blue) / 3
     */
    JKImageByGrayscaleTypeAverage,
    
    /**
     人眼感知算法，按照人类对光的感知程度为每个颜色设定一个权重（绿 > 红 > 蓝）
     灰度计算公式：Gray = (Red * 0.3 + Green * 0.59 + Blue * 0.11)
     */
    JKImageByGrayscaleTypeEyesPerception,
    
    /**
     去饱和算法，把 RGB 转换为 HLS，然后将饱和度设为 0。
     灰度计算公式：Gray = (Max(Red, Green, Blue) + Min(Red, Green, Blue)) / 2
     效果：图像立体感减弱，但是更柔和
     */
    JKImageByGrayscaleTypeDesaturation,
    
    /**
     最大值分解算法，图片会更亮
     灰度计算公式：Gray = Max(Red, Green, Blue)
     */
    JKImageByGrayscaleTypeDecompositionMax,
    
    /**
     最小值分解算法，图片会更暗
     灰度计算公式：Gray = Min(Red, Green, Blue)
     */
    JKImageByGrayscaleTypeDecompositionMin,
    
    /**
     单一通道算法，取红色通道
     灰度计算公式：Gray = Red
     */
    JKImageByGrayscaleTypeSingleChannelWithRed,
    
    /**
     单一通道算法，取绿色通道
     灰度计算公式：Gray = Green
     */
    JKImageByGrayscaleTypeSingleChannelWithGreen,
    
    /**
     单一通道算法，取蓝色通道
     灰度计算公式：Gray = Blue
     */
    JKImageByGrayscaleTypeSingleChannelWithBlue,
    
};

/**
 ### 参考
 * [6 种图片灰度转换算法](https://zhuanlan.zhihu.com/p/31840238)
 
 ### HLS 模型
 * Hue (色调)：取值为：0 - 360，0 (或 360) 表示红色，120 表示绿色，240 表示蓝色，也可取其他数值来指定颜色。
 * Saturation (饱和度)：取值为：0.0% - 100.0%，它通常指颜色的鲜艳程度。
 * Lightness (亮度)：取值为：0.0% - 100.0%，黑色的亮度为 0。
 
 */
@interface UIImage (PixelMix)

- (UIImage *)grayImageWithType:(JKImageByGrayscaleType)grayscaleType;

/**
 自定义灰度阴影，多用于艺术效果
 NumberOfShades 的范围在 2-256，2 的结果是一张全白的图片，256 的结果和平均值算法一样。
 
 灰度计算公式：
 ConversionFactor = 255 / (NumberOfShades - 1)
 AverageValue = (Red + Green + Blue) / 3
 Gray = Math.round((AverageValue / ConversionFactor) + 0.5) * ConversionFactor
 */
- (UIImage *)grayImageWithNumberOfShades:(NSUInteger)numberOfShades;

@end

NS_ASSUME_NONNULL_END
