//
//  UIImage+fixOrientation.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/3/1.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 解决裁剪后的图片自动旋转90°再显示的问题
 原因：iPhone原始图像被拍摄后的EXIF方向值是6，被裁剪后方向信息会被删除，置为1。
 原理：在人像识别之前先修改图像的EXIF信息为1，再进行人像识别。
 */
@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

@end
