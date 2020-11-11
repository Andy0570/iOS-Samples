//
//  HQLAVFoundation01ViewController.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 原生代码实现拍摄照片功能。

 MARK: 使用 AVFoundation 拍摄照片并保存到系统相册。
 
 在 iOS 10 之前，自定义相机拍摄照片时，使用 AVCaptureStillImageOutput 作为输出数据对象。iOS 10 之后，AVCaptureStillImageOutput 已经被废弃了。
 现在需要使用 AVCapturePhotoOutput 作为输出数据对象。
 
 AVCapturePhotoOutput 的功能自然会更加强大，不仅支持简单的 JPEG 图片拍摄，还支持 Live 照片和 RAW 格式拍摄。
 AVCapturePhotoOutput 是一个功能强大的类，在新系统中也不断有新的功能接入，比如 iOS11 支持双摄和获取深度数据，iOS 12 支持人像模式等。
*/
@interface HQLAVFoundation01ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
