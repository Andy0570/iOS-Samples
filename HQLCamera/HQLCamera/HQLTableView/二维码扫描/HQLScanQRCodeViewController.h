//
//  HQLScanQRCodeViewController.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLScanQRCodeViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 ## AVFoundation 框架
 
 AVCaptureSession：媒体捕获会话，负责把捕获的音视频数据输出到输出设备中。

 AVCaptureDevice：输入设备，如麦克风、摄像头。

 AVCaptureDeviceInput：设备输入数据管理对象，可以根据 AVCaptureDevice 创建对应的 AVCaptureDeviceInput 对象，该对象将会被添加到 AVCaptureSession 中管理。

 AVCaptureOutput：输出数据管理对象，用于接收各类输出数据，有很多子类，每个子类用途都不一样，该对象将会被添加到 AVCaptureSession 中管理。

 AVCaptureVideoPreviewLayer：相机拍摄预览图层，是 CALayer 的子类，使用该对象可以实时查看拍照或视频录制效果，设置好尺寸后需要添加到父 view 的 layer 中。
 
 
 参考：<https://www.jianshu.com/p/1919b240387b>
 
 */
