//
//  UIImage+Composition.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/18.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "UIImage+Composition.h"
#import <GPUImage/GPUImage.h>

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

@implementation UIImage (Composition)

// 直接合成图片
+ (UIImage *)compositionWithBackImage:(UIImage *)backImage
                           frontImage:(UIImage *)frontImage
{
    // 1. 获取图像的原始像素
    UInt32 *backImagePixels;
    
    CGImageRef backImageCGImage = [backImage CGImage];
    NSUInteger backImagePixelsWidth = CGImageGetWidth(backImageCGImage);
    NSUInteger backImagePixelsHeight = CGImageGetHeight(backImageCGImage);
    
    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytePerPixel = 4;
    // 每个颜色分量的大小 RGBA 每一个分量占1个字节
    NSUInteger bitsPerComponent = 8;
    // 每一行使用的字节数 4*width
    NSUInteger backImageBytePerRow = bytePerPixel * backImagePixelsWidth;
    
    // 根据像素点个数创建一个所需要的空间
    backImagePixels = (UInt32 *)calloc(backImagePixelsHeight * backImagePixelsWidth, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(backImagePixels, backImagePixelsWidth, backImagePixelsHeight, bitsPerComponent, backImageBytePerRow, colorSpace,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // 根据图片数据源绘制上下文
    CGContextDrawImage(context, CGRectMake(0, 0, backImagePixelsWidth, backImagePixelsHeight), backImageCGImage);
    
    // 2. 将另一张图像混合添加到父图像上
    CGImageRef frontImageCGImage = [frontImage CGImage];
    
    // 2.1 计算图案的大小和位置
    CGFloat frontImageAspectRatio = frontImage.size.width / frontImage.size.height;
    NSInteger targetFrontImageWidth = backImagePixelsWidth * 0.25;
    CGSize frontSize = CGSizeMake(targetFrontImageWidth, targetFrontImageWidth / frontImageAspectRatio);
    
    CGPoint frontImageOrigin = CGPointMake(0, 0);
    
    // 2.2 缩放、获取图案的像素
    NSUInteger frontImageBytesPerRow = bytePerPixel * frontSize.width;
    UInt32 *frontImagePixels = (UInt32 *)calloc(frontSize.width * frontSize.height, sizeof(UInt32));
    CGContextRef frontContext = CGBitmapContextCreate(frontImagePixels, frontSize.width, frontSize.height, bitsPerComponent, frontImageBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(frontContext, CGRectMake(0, 0, frontSize.width, frontSize.height), frontImageCGImage);
    
    // 2.3 混合每个像素值
    NSUInteger offsetPixelCountForInput = frontImageOrigin.y * backImagePixelsWidth + frontImageOrigin.x;
    for (NSUInteger j = 0; j < frontSize.height; j++) {
        for (NSUInteger i = 0; i < frontSize.width; i++) {
            UInt32 *backPixel = backImagePixels + j * backImagePixelsWidth + i + offsetPixelCountForInput;
            UInt32 backColor = *backPixel;

            UInt32 * frontPixel = frontImagePixels + j * (int)frontSize.width + i;
            UInt32 frontColor = *frontPixel;

            // 使用 50% 的透明度混合模式
            // CGFloat frontAlpha = 0.5f * (A(frontColor) / 255.0);
            CGFloat frontAlpha = 1.0f * (A(frontColor) / 255.0);
            UInt32 newR = R(backColor) * (1 - frontAlpha) + R(frontColor) * frontAlpha;
            UInt32 newG = G(backColor) * (1 - frontAlpha) + G(frontColor) * frontAlpha;
            UInt32 newB = B(backColor) * (1 - frontAlpha) + B(frontColor) * frontAlpha;

            // Clamp, not really useful here :p
            newR = MAX(0,MIN(255, newR));
            newG = MAX(0,MIN(255, newG));
            newB = MAX(0,MIN(255, newB));

            *backPixel = RGBAMake(newR, newG, newB, A(backColor));
        }
    }
        
    // 3. Create a new UIImage
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage *processedImage = [UIImage imageWithCGImage:newCGImage];

    // 4. Cleanup!
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGContextRelease(frontContext);
    free(backImagePixels);
    free(frontImagePixels);

    return processedImage;
}

// CoreGraphics
+ (UIImage *)compositionCoreGraphicsWithBackImage:(UIImage *)backImage
                                       frontImage:(UIImage *)frontImage
{
    CGRect imageRect = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    
    CGImageRef backImageCGImage = backImage.CGImage;
    CGFloat backImageWidth = CGImageGetWidth(backImageCGImage);
    CGFloat backImageHeight = CGImageGetHeight(backImageCGImage);
    
    // 1. 将图案混合到图像上
    // 1.1 计算图案的大小和位置
    CGFloat frontImageAspectRatio = frontImage.size.width / frontImage.size.height;
    NSInteger targetFrontImageWidth = backImageWidth * 0.25;
    CGSize frontImageSize = CGSizeMake(targetFrontImageWidth, targetFrontImageWidth / frontImageAspectRatio);
    CGPoint frontImageOrigin = CGPointMake(0, 0);
    CGRect frontImageRect = {frontImageOrigin, frontImageSize};
    
    UIGraphicsBeginImageContext(backImage.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 翻转绘图的背景
    CGAffineTransform flip = CGAffineTransformMakeScale(1.0, -1.0);
    CGAffineTransform flipThenShift = CGAffineTransformTranslate(flip,0,-backImageHeight);
    CGContextConcatCTM(context, flipThenShift);
    
    // 1.1 将图像画到一个新的 CGContext 中
    CGContextDrawImage(context, imageRect, backImageCGImage);
    
    // 1.2 使用 50% 的透明度混合模式
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextSetAlpha(context, 0.5);
    CGRect transformedpatternRect = CGRectApplyAffineTransform(frontImageRect, flipThenShift);
    CGContextDrawImage(context, transformedpatternRect, [frontImage CGImage]);
    
    UIImage *imageWithFront = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return imageWithFront;
}


// CoreImage
- (UIImage *)compositionCoreImageWithBackImage:(UIImage *)backImage
                                    frontImage:(UIImage *)frontImage
{
    CIImage * backCIImage = [[CIImage alloc] initWithImage:backImage];
    
    // 1. Create a grayscale filter
    CIFilter * grayFilter = [CIFilter filterWithName:@"CIColorControls"];
    [grayFilter setValue:@(0) forKeyPath:@"inputSaturation"];
    
    // 2. Create our pattern filter
    
    // Cheat: create a larger pattern image
    UIImage * patternFrontImage = [self createPaddedPatternImageWithSize:backImage.size pattern:frontImage];
    CIImage * frontCIImage = [[CIImage alloc] initWithImage:patternFrontImage];

    CIFilter * alphaFilter = [CIFilter filterWithName:@"CIColorMatrix"];
    //  CIVector * alphaVector = [CIVector vectorWithX:0 Y:0 Z:0.5 W:0];
    CIVector * alphaVector = [CIVector vectorWithX:0 Y:0 Z:1.0 W:0];
    [alphaFilter setValue:alphaVector forKeyPath:@"inputAVector"];
    
    CIFilter * blendFilter = [CIFilter filterWithName:@"CISourceAtopCompositing"];
    
    // 3. Apply our filters
    [alphaFilter setValue:frontCIImage forKeyPath:@"inputImage"];
    frontCIImage = [alphaFilter outputImage];

    [blendFilter setValue:frontCIImage forKeyPath:@"inputImage"];
    [blendFilter setValue:backCIImage forKeyPath:@"inputBackgroundImage"];
    CIImage * blendOutput = [blendFilter outputImage];
    
    [grayFilter setValue:blendOutput forKeyPath:@"inputImage"];
    CIImage * outputCIImage = [grayFilter outputImage];
    
    // 4. Render our output image
    CIContext * context = [CIContext contextWithOptions:nil];
    CGImageRef outputCGImage = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    UIImage * outputImage = [UIImage imageWithCGImage:outputCGImage];
    CGImageRelease(outputCGImage);
    
    return outputImage;
}


// 生成自定义的 pattern 图案
- (UIImage *)createPaddedPatternImageWithSize:(CGSize)containerSize pattern:(UIImage *)pattern{
//  UIImage * patternImage = [UIImage imageNamed:@"pattern.png"];
  CGFloat patternImageAspectRatio = pattern.size.width / pattern.size.height;
  
  NSInteger targetPatternWidth = containerSize.width * 0.25;
  CGSize patternSize = CGSizeMake(targetPatternWidth, targetPatternWidth / patternImageAspectRatio);
  //  CGPoint patternOrigin = CGPointMake(containerSize.width * 0.5, containerSize.height * 0.2);
  CGPoint patternOrigin = CGPointMake(0, 0);
  
  CGRect patternRect = {patternOrigin, patternSize};
  
  UIGraphicsBeginImageContext(containerSize);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGRect containerRect = {CGPointZero, containerSize};
  CGContextClearRect(context, containerRect);

  CGAffineTransform flip = CGAffineTransformMakeScale(1.0, -1.0);
  CGAffineTransform flipThenShift = CGAffineTransformTranslate(flip,0,-containerSize.height);
  CGContextConcatCTM(context, flipThenShift);
  CGRect transformedPatternRect = CGRectApplyAffineTransform(patternRect, flipThenShift);
  CGContextDrawImage(context, transformedPatternRect, [pattern CGImage]);
  
  UIImage * paddedpattern = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return paddedpattern;
}

- (UIImage *)processUsingGPUImage:(UIImage *)backImage frontImage:(UIImage *)frontImage {
    
    // 1. Create our GPUImagePictures
    GPUImagePicture * backGPUImage = [[GPUImagePicture alloc] initWithImage:backImage];
    
    UIImage *fliterImage = [self createPaddedPatternImageWithSize:backImage.size pattern:frontImage];
    GPUImagePicture * frontGPUImage = [[GPUImagePicture alloc] initWithImage:fliterImage];
    
    // 2. Setup our filter chain
    GPUImageAlphaBlendFilter * alphaBlendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    alphaBlendFilter.mix = 0.5;
    
    [backGPUImage addTarget:alphaBlendFilter atTextureLocation:0];
    [frontGPUImage addTarget:alphaBlendFilter atTextureLocation:1];
    
    GPUImageGrayscaleFilter * grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
    
    [alphaBlendFilter addTarget:grayscaleFilter];
    
    // 3. Process & grab output image
    [backGPUImage processImage];
    [frontGPUImage processImage];
    [grayscaleFilter useNextFrameForImageCapture];
    
    UIImage * output = [grayscaleFilter imageFromCurrentFramebuffer];
    
    return output;
}

@end
