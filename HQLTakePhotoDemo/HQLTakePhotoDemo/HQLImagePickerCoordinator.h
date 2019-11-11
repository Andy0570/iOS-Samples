//
//  HQLImagePickerCoordinator.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/3/1.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HQLImagePickerCoordinatorFinishPickingImageDelegate <NSObject>

@required
- (void)resultPickingImage:(UIImage *)image;

@end


/**
 图片选择协调器
 */
@interface HQLImagePickerCoordinator : NSObject

// 相机是否可用
@property (nonatomic, assign, readonly) BOOL isCameraAvailable;
@property (nonatomic, assign, readonly) BOOL isPhotoLibraryAvailable;
@property (nonatomic, strong, readonly) UIImagePickerController *imagePickerController;
@property (nonatomic, weak) NSObject<HQLImagePickerCoordinatorFinishPickingImageDelegate> *delegate;

// 务必设置图片数据源类型
- (void)setImageSourceType:(UIImagePickerControllerSourceType)sourceType;

@end
