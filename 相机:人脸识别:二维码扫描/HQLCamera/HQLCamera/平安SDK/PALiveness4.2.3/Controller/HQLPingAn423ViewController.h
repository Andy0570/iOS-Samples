//
//  HQLPingAn423ViewController.h
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/5/27.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 平安SDK 4.2.3 集成示例
 
 【说明】平安的活体检测 SDK 主要功能是这个接口：
 将图片传入检测器进行异步活体检测，检测结果将以异步的形式通知delegate。
 -(bool)detectWithImage:(UIImage*)img;
 
 也就是说，它只有一个让你发送拍摄照片的接口，UI 界面的用户交互、语音提示都需要你自己去实现（SDK 不完整）！
 用户交互可以参考借鉴商汤的 SDK！
 */
@interface HQLPingAn423ViewController : UIViewController

@end
