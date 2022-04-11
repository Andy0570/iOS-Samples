//
//  HQLFaceDetectorViewController.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 使用 Core Image 框架实现的人脸识别
 
 Core Image 框架可以进行图像处理和视频图像处理
 
 【已知问题】
 识别成功率低、
 裁剪问题（识别不出人脸、或者识别出人脸但是裁剪出了左眼）、
 图片中的人脸也能识别，无法实现常见商业场景中的活体检测功能、
 
 参考：
 * <https://www.jianshu.com/p/e371099f12bd>
 * <https://www.cnblogs.com/zhanggui/p/4743128.html>
 */
@interface HQLFaceDetectorViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 MARK: 人脸识别核心源码
 
 - (void)faceDetectWithImage:(UIImage *)image {
     // 图像识别能力：可以在CIDetectorAccuracyHigh(较强的处理能力)与CIDetectorAccuracyLow(较弱的处理能力)中选择
     NSDictionary *opts = [NSDictionary dictionaryWithObject:
                           CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
     // 将图像转换为CIImage
     CIImage *faceImage = [CIImage imageWithCGImage:image.CGImage];
     CIDetector *faceDetector=[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
     // 识别出人脸数组
     NSArray *features = [faceDetector featuresInImage:faceImage];
     // 得到图片的尺寸
     CGSize inputImageSize = [faceImage extent].size;
     //将image沿y轴对称
     CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
     //将图片上移
     transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
     
     // 取出所有人脸
     for (CIFaceFeature *faceFeature in features){
         //获取人脸的frame
         CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
         CGSize viewSize = _imageView.bounds.size;
         CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                             viewSize.height / inputImageSize.height);
         CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
         CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
         // 缩放
         CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
         // 修正
         faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
         faceViewBounds.origin.x += offsetX;
         faceViewBounds.origin.y += offsetY;
     
         //描绘人脸区域
         UIView* faceView = [[UIView alloc] initWithFrame:faceViewBounds];
         faceView.layer.borderWidth = 2;
         faceView.layer.borderColor = [[UIColor redColor] CGColor];
         [_imageView addSubview:faceView];
     
         // 判断是否有左眼位置
         if(faceFeature.hasLeftEyePosition){}
         // 判断是否有右眼位置
         if(faceFeature.hasRightEyePosition){}
         // 判断是否有嘴位置
         if(faceFeature.hasMouthPosition){}
     }
 }
 */
