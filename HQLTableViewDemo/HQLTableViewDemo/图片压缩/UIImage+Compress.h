//
//  UIImage+Compress.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/17.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compress)

// 1.简单压缩
// 按照图片质量压缩
// 主要弊端：如果有大图按这个方法，尺寸有可能依然很大
- (UIImage *)compressWithQuality:(CGFloat)compressionQuality;

// 按照图片尺寸压缩，（严格意义上，只是调整图片尺寸）
// 主要弊端：图片可能会变形，质量也无法保证
// 输入的 size 尺寸需要保证是图片等比例缩小的尺寸，图片才不会变形
- (UIImage *)compressWithSize:(CGSize)size;

// 2.更加精细的压缩：例如要求图片小于100k

// 循环压缩图片质量直到图片存储字节数稍小于指定大小
// ⚠️ 当图片质量低于一定程度时，继续压缩没有效果。默认压缩最多6次，通过二分法来优化循环次数多
// 压缩图片质量的优点在于，尽可能保留图片清晰度，图片不会明显模糊；缺点在于，不能保证图片压缩后小于指定大小。
- (UIImage *)loopCompressWithQuality:(NSInteger)maxLength;

// 循环逐渐减小图片尺寸，直到图片存储字节数稍小于指定大小
// 同样的问题是循环次数多，效率低，耗时长。可以用二分法来提高效率，具体代码省略。
// 这里介绍另外一种方法，比二分法更好，压缩次数少，而且可以使图片压缩后刚好小于指定大小(不只是 < maxLength， > maxLength * 0.9)。
- (UIImage *)loopCompressWithSize:(NSInteger)maxLength;

// 3.两种图片压缩方法结合，尽量兼顾质量和大小。以确保大小合适为标准
// 如果要保证图片清晰度，建议选择压缩图片质量。如果要使图片一定小于指定大小，压缩图片尺寸可以满足。
// 对于后一种需求，还可以先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸。
- (UIImage *)compressWithQulitySize:(NSInteger)maxLength;

// 4.强制图片解码，按大小比例压缩sacle (0,1] - 也可放大,清晰度会受到影响；
// 适用于需要快速显示图片的地方，例如 tableCell，先把图片进行 bitmap 位图解码操作，存入缓存。
// 解决方案：通过 CGBitmapContextCreate 重绘图片，这种压缩的图片等于手动进行了一次解码，可以加快图片的展示。
- (UIImage *)compressWithBitmap:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
