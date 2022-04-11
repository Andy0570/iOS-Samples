//
//  HQLCamera02ViewController.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/10.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 1. 使用 UIImagePickerController 选择图片，支持从相册获取或者打开相机拍摄，并保存到系统相册。
 2. 通过 <HXPhotoPicker> 框架中的 HXPhotoBottomSelectView 类实现弹窗效果（类似微信发布朋友圈选择图片弹窗）。
 3. 界面适配深色模式。
 
 【问题记录】选择拍照模式，在摄像头捕捉页面中从拍摄照片切换到视频，应用崩溃，报错：Thread 4: signal SIGABRT
 【问题原因】info.plist 中没有或者少配置了隐私权限设置，拍摄视频时，不仅需要相机权限，还需要麦克风权限。
  
 Privacy - Camera Usage Description
 Privacy - Microphone Usage Description
 
 参考：<https://stackoverflow.com/questions/45297745/im-trying-to-make-the-recording-camera-come-up-it-crashes-with-signal-sigabrt>
 */
@interface HQLCamera02ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
