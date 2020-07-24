//
//  PALivenessDetector.h
//  PALivenessDetector
//
//  Created by 刘沛荣 on 15/11/3.
//  Copyright © 2015年 PA. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
 * Environmental ErrorEnum

 */
typedef enum EnvironmentalErrorEnum {
    
    ENVIORNMENT_ERROR_TOOCLSE = 0,              /// <过近<请稍微退后>
    ENVIORNMENT_ERROR_TOOFAR = 1,               /// <过远<请稍微靠近>
    ENVIORNMENT_ERROR_TOOBRIGHT = 2,            /// <过于明亮
    ENVIORNMENT_ERROR_TOODARK = 3,              /// <过于灰暗
    ENVIORNMENT_ERROR_TOOPARTIAL = 4,           /// <过于偏转<请稍微正对摄像头>
    ENVIORNMENT_ERROR_NOFACE = 5,               /// <没有人脸<请稍微正对摄像头>
    ENVIORNMENT_ERROR_FUZZY = 6,                /// <图片模糊值过高
    ENVIORNMENT_ERROR_MOVEMENT = 7,             /// <请保持相对静止
    ENVIORNMENT_ERROR_MULTIFACE = 8,            /// <多人存在
    ENVIORNMENT_ERROR_NORMAL = 9                /// <正常
    
} DetectErrorEnum;

/*
 * PALivenessDetectionType
 * 检测类型选项
 */
typedef enum PALivenessDetectionType {
    
    DETECTION_TYPE_FACE = 1001,        // 正脸--必须--合格
    DETECTION_TYPE_MouthOpen = 1002,   // 张嘴---选择
    DETECTION_TYPE_YAW = 1003,         // 摇头---选择
    DETECTION_TYPE_ONERANDOM = 1004,   // 随机选取一个动作
    DETECTION_TYPE_ALLRANDOM = 1005,   // 两个动作随机顺序
    
} DetectMotionType;

/*
 *  PALivenessDetectionFailedType
 *  检测失败类型
 */
typedef enum PALivenessDetectionFailedType {
    
    DETECTION_FAILED_TYPE_ACTIONBLEND = 0,         //动作错误
    DETECTION_FAILED_TYPE_DiscontinuityAttack,     //非连续性攻击
    
} DetectionFailedType;

/*
 *  图片中的人脸属性
 */
struct PAFaceAttr{
    
    /** 是否包含人脸 */
    bool has_face;
    /** 左右旋转角度 */
    float yaw;
    /** 上下旋转角度 */
    float pitch;
    /** 运动模糊程度 */
    float blurness_motion;
    /** 人脸位置 */
    CGRect face_rect;
    /** 眼睛睁闭 */
    boolean_t eye_hwratio;
    /** 亮度 */
    float brightness;
    /** 高斯模糊 */
    float gaussian;
    /** 水平偏角 */
    float deflecion_h;
    /** 上下偏角 */
    float deflecion_v;
    /** 左眼坐标 */
    CGPoint eye_left;
    /** 右眼坐标 */
    CGPoint eye_right;
    /** 图片质量 */
    float quality;
    
};

/*
 *  单帧检测结果的类，包含单帧检测出人脸的所有属性，此类无需构造，仅用于回调
 */
@interface PALivenessDetectionFrame : NSObject

/** 检测帧对应图片 */
@property (readonly) UIImage* image;
/** 图片中的人脸属性 */
@property (readonly) struct PAFaceAttr attr;

@end

/*
 *  此接口通过 PALivenessDetector 的 setDelegate 函数进行注册，在活体检测的过程中会经由不同的事件触发不同的回调方法
 */
@protocol PALivenessProtocolDelegate <NSObject>

@required

/**
 1. 用户行为的建议
 
 @param detectTip 用户行为的建议
 */
-(void)onDetectTips:(DetectErrorEnum)detectTip;

/**
 2. 活体检测动作回调，当前活体检测更换动作时调用

 @param motionType 动作类型
 */
-(void)onDetectMotionTips:(DetectMotionType)motionType;

/**
 3. 动作检测成功

 @param faceInfo 关键帧信息
 */
- (void)onDetectionSuccess:(PALivenessDetectionFrame *)faceInfo;

/*
 4. 错误类型回调
 
 @param failedType 错误类型
 */
-(void)onDetectFailed:(DetectionFailedType)failedType;

@end

@interface PALivenessDetector : NSObject

/**
 初始化方法
 
 @param detectionType 动作类型
 @param livenessdelegate 代理
 @return obj
 */
+(PALivenessDetector *)detectorOfWithDetectionType:(PALivenessDetectionType)detectionType delegate:(id<PALivenessProtocolDelegate>)livenessdelegate;

/**
 获取版本信息

 @return 版本描述
 */
+(NSString *)getVersion;

/**
 将图片传入检测器进行异步活体检测，检测结果将以异步的形式通知delegate。
 
 @param img 待测图片序列
 @return 检测是否成功
 */

-(bool)detectWithImage:(UIImage*)img;

/**
 重置检测器，当用户需要重新开始活体检测流程时，调用此函数。

 @param motionType 动作类型
 */
-(void)resetWithDetectionType:(DetectMotionType)motionType;

@end


