//
//  IDImagePickerCoordinator.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 视频选择协调器
/// 使用 <Photos/Photos.h> 框架保存视频
@interface IDImagePickerCoordinator : NSObject

- (UIImagePickerController *)imagePicker;

@end

NS_ASSUME_NONNULL_END
