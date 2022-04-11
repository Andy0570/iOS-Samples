//
//  HQLPhotoPicker02ViewController.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/11/16.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HXPhotoManager;

/// 这是下一个视图控制器页面，当选择照片/拍照完成后，跳转到该页面
@interface HQLPhotoPicker02ViewController : UIViewController
@property (nonatomic, strong) HXPhotoManager *manager;
@end

NS_ASSUME_NONNULL_END
