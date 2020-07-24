//
//  HQLImagePickerCoordinator.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/7/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HQLImagePickerCoordinatorDelegate <NSObject>

@required
// 拍摄照片的回调
- (void)resultPickingImage:(UIImage *)image;

@end

/// 图片选择协调器
@interface HQLImagePickerCoordinator : NSObject

@property (nonatomic, assign, readonly) BOOL isCameraAvailable;
@property (nonatomic, assign, readonly) BOOL isPhotoLibraryAvailable;
@property (nonatomic, strong, readonly) UIImagePickerController *imagePickerController;
@property (nonatomic, weak) NSObject<HQLImagePickerCoordinatorDelegate> *delegate;

// 务必设置图片数据源类型
- (void)setImagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType;

@end

NS_ASSUME_NONNULL_END
