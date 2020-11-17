//
//  PALivenessController.h
//  HQLCamera
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

/**
 * 【说明】
 * 该视图控制器用于「平安活体检测SDK 4.2.3」。
 * 定制化 UI，内部封装了自动打开相机、各步骤语音、动画、文字提示、录制视频并传入图片进行活体检测等功能。
 * 参考了 「商汤活体检测 SDK3.5」 中的 STLivenessController 及相关资源文件。
 *
 */

#import <UIKit/UIKit.h>
#import "PALivenessDetector.h"

/**
 活体检测失败枚举类型
 */
typedef NS_ENUM(NSUInteger, PALivenessControllerDetectionFailureType) {
    PALivenessControllerDetectionFailureTypeActionBlend,         // 动作错误
    PALivenessControllerDetectionFailureTypeDiscontinuityAttack, // 非连续性攻击
    PALivenessControllerDetectionFailureTypeTimeOut,             // 检测超时
    PALivenessControllerDetectionFailureTypeCameraDenied         // 相机权限获取失败
};

/**
 活体检测器代理
 */
@protocol PALivenessDetectorDelegate <NSObject>

@required


/**
 活体检测成功回调

 @param faceImage  人脸正面照（即上传到服务器的照片）
 @param info       人脸正面照信息（自主选择）
 */
- (void)livenessDidSuccessfulWithFaceImage:(UIImage *)faceImage faceImageInfo:(NSDictionary *)info;


/**
 活体检测失败回调

 @param errorType 活体检测失败枚举类型
 */
- (void)livenessDidFailWithErrorType:(PALivenessControllerDetectionFailureType)errorType;


/**
 活体检测被取消的回调
 */
- (void)livenessDidCancel;


@end


/**
 活体检测视图控制器
 */
@interface PALivenessController : UIViewController

// 设置语音提示默认是否开启 , 不设置时默认为YES即开启;
@property (nonatomic, assign) BOOL isVoicePrompt;

@property (nonatomic, strong) PALivenessDetector *detector; // 活体检测器

/**
 初始化方法

 @param delegate 回调代理
 @param detectionType 活体检测类型选项
 @return 活体检测器实例
 */
- (instancetype)initWithSetDelegate:(id<PALivenessDetectorDelegate>)delegate
              livenessDetectionType:(PALivenessDetectionType)detectionType;

@end
