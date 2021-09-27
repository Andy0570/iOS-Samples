//
//  UIImage+Compress.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/17.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

// 按照质量压缩
- (UIImage *)compressWithQuality:(CGFloat)compressionQuality {
    NSData *data = UIImageJPEGRepresentation(self, compressionQuality);
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

// 按照尺寸压缩
- (UIImage *)compressWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

// 循环压缩图片质量直到图片稍小于指定大小
- (UIImage *)loopCompressWithQuality:(NSInteger)maxLength {
    CGFloat compressionQuality = 1;
    NSData *data = UIImageJPEGRepresentation(self, compressionQuality);
    if (data.length < maxLength) {
        return self;
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compressionQuality = (max + min) / 2.0;
        data = UIImageJPEGRepresentation(self, compressionQuality);
        if (data.length < maxLength * 0.9) {
            min = compressionQuality;
        } else if (data.length > maxLength) {
            max = compressionQuality;
        } else {
            break;
        }
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}

// 循环逐渐减小图片尺寸，直到图片稍小于指定大小
- (UIImage *)loopCompressWithSize:(NSInteger)maxLength {
    UIImage *resultImage = self;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        // Use NSUInteger to prevent white blank
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height *  sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}

// 3.两种图片压缩方法结合 尽量兼顾质量和大小。以确保大小合适为标准
// 如果要保证图片清晰度，建议选择压缩图片质量。如果要使图片一定小于指定大小，压缩图片尺寸可以满足。
// 对于后一种需求，还可以先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸。
- (UIImage *)compressWithQulitySize:(NSInteger)maxLength {
    // Compress by quality
    CGFloat compressionQuality = 1;
    NSData *data = UIImageJPEGRepresentation(self, compressionQuality);
    if (data.length < maxLength) {
        return self;
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compressionQuality = (max + min) / 2.0;
        data = UIImageJPEGRepresentation(self, compressionQuality);
        if (data.length < maxLength * 0.9) {
            min = compressionQuality;
        } else if (data.length > maxLength) {
            max = compressionQuality;
        } else {
            break;
        }
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) {
        return resultImage;
    }
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        // Use NSUInteger to prevent white blank
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height *  sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    
    return resultImage;
}

- (UIImage *)compressWithBitmap:(CGFloat)scale {
    // 获取当前图片数据源
    CGImageRef imageRef = self.CGImage;
    // 设置大小，改变压缩图片
    scale = scale != 0 ? scale : [UIScreen mainScreen].scale;
    NSUInteger width = CGImageGetWidth(imageRef) * scale;
    NSUInteger height = CGImageGetHeight(imageRef) * scale;
    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);

    /**
     创建绘制当前图片的上下文
     
     CGBitmapContextCreate(void * __nullable data,
         size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow,
         CGColorSpaceRef cg_nullable space, uint32_t bitmapInfo)
     参数描述：
     data：所需要的内存空间，传 nil 会自动分配；
     width/height：当前画布的大小
     bitsPerComponent：每个颜色分量的大小 RGBA 每一个分量占1个字节
     bytesPerRow：每一行使用的字节数 4*width
     bitmapInfo：RGBA绘制的顺序
     */
    CGContextRef contextRef = CGBitmapContextCreate(nil, width, height, 8, 4 * width, colorSpace, kCGImageAlphaNoneSkipLast);
    // 根据数据源在上下文（画板）绘制图片
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    imageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
    CGContextRelease(contextRef);
    CGImageRelease(imageRef);
    
    return resultImage;
}

@end
