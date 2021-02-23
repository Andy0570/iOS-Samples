//
//  SecondViewController.h
//  HQLAudioRecorder
//
//  Created by Qilin Hu on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecondViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

/**
 在这个示例中将实现一个完整的录音控制，包括录音、暂停、恢复、停止，同时还会实时展示用户录音的声音波动，当用户点击停止按钮还会自动播放录音文件。程序的构建主要分为以下几步：

 * 设置音频会话类型为 `AVAudioSessionCategoryPlayAndRecord` ，因为程序中牵扯到录音和播放操作。
 * 创建录音机 `AVAudioRecorder` ，指定录音保存的路径并且设置录音属性，注意对于一般的录音文件要求的采样率、位数并不高，需要适当设置以保证录音文件的大小和效果。
 * 设置录音机代理以便在录音完成后播放录音，打开录音测量保证能够实时获得录音时的声音强度。（注意声音强度范围 `-160` 到 `0` ， `0` 代表最大输入）
 * 创建音频播放器 `AVAudioPlayer` ，用于在录音完成之后播放录音。 创建一个定时器以便实时刷新录音测量值并更新录音强度到 `UIProgressView` 中显示。
 * 添加录音、暂停、恢复、停止操作，需要注意录音的恢复操作其实是有音频会话管理的，恢复时只要再次调用 `record` 方法即可，无需手动管理恢复时间等。
 */
