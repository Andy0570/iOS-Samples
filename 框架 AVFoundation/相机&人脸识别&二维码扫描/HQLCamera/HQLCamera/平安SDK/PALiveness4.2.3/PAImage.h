//
//  PAImage.h
//  PAVideoRecodeSDK
//
//  Created by prliu on 2017/7/18.
//  Copyright © 2017年 pingan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface PAImage : NSObject

/**
 *  裁剪图片
 *
 *  @param image  原始图片
 *  @param bounds 裁剪的区域
 *
 *  @return 裁剪后的图片
 */
UIImage* PACroppedImage(UIImage *image, CGRect bounds);

/**
 *  修正图片方向
 *
 *  @param image 原始图片
 *
 *  @return 修正完成的图片
 */
UIImage* PAFixOrientationWithImage(UIImage *image);

UIImage* PAFixOrientationWithImageOrientation(UIImage *image, UIImageOrientation orientation);

/**
 *  把sampleBuffer转化为图片
 *
 *  @param sampleBuffer sampleBuffer
 *  @param orientation  图片的方向
 *
 *  @return 转化完成的图片
 */
UIImage* PAImageFromSampleBuffer(CMSampleBufferRef sampleBuffer, UIImageOrientation orientation);

/**
 把yuv_sampleBuffer转化为图片
 
 @param sampleBuffer sampleBuffer
 @return 转化完成的图片
 */
UIImage* PAImageFromYuvSampleBuffer(CMSampleBufferRef sampleBuffer);

/**
 把sampleBuffer转化为图片同时修正
 
 @param sampleBuffer sampleBuffer
 @param orientation 图片的方向
 @return 转化完成的图片
 */
UIImage* PAFixOrientationFromSampleBuffer(CMSampleBufferRef sampleBuffer, UIImageOrientation orientation);

/*视频角度转化为数值*/
CGFloat PAAngleOffsetFromPortraitOrientationToOrientation(AVCaptureVideoOrientation orientation);


/**
 纯色图片
 
 @param color 颜色
 @return 图片
 */
UIImage *PACreateImageWithColor(UIColor *color,CGRect rect);


/**
 缩放图片
 @param image 原始图片
 @param newSize 新的尺寸
 @param quality 缩放质量
 @return 新图片
 */
UIImage *PAResizedImage(UIImage *image,CGSize newSize,CGInterpolationQuality quality) ;


/**
 缩放图片
 
 @param image 原始图片
 @param newSize 新的尺寸
 @param transform 旋转
 @param transpose 镜像
 @param quality 质量
 @return 新图片
 */
UIImage *PAResizedImage(UIImage*image, CGSize newSize
                        ,CGAffineTransform transform
                        ,BOOL transpose,
                        CGInterpolationQuality quality) ;

@end
