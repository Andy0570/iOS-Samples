//
//  HQLTakePhotoViewController.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 原生代码实现照片选择器功能
 
 1. 使用 UIImagePickerController 拍摄照片并保存到系统相册。
 2. 对图片进行 base64 编码并上传到服务器。
 */
@interface HQLTakePhotoViewController : UIViewController

@end

NS_ASSUME_NONNULL_END


/**
 Swift 代码参考：<https://xiaovv.me/2017/09/20/Use-UIImagePickerController-in-iOS/>
 
 let imagePicker: UIImagePickerController! = UIImagePickerController()

 func shootADance() {

      if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
         if UIImagePickerController.availableCaptureModes(for: .rear) != nil {

             // if the camera and rear camera is available, dod this
             imagePicker.sourceType = .camera
             imagePicker.mediaTypes = [kUTTypeMovie as String]
             imagePicker.allowsEditing = false
             imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate

             present(imagePicker, animated: true, completion: nil)
         } else {
             postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
         }
     } else {
         postAlert("Camera inaccessable", message: "Application cannot access the camera.")
     }
 }
 */
