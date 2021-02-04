//
//  HQLDemo3ViewController.h
//  NSURLSession
//
//  Created by Qilin Hu on 2020/4/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 创建 NSURLSessionUploadTask 上传任务
 
 1. 上传 Data 数据
 2. 上传 File 文件
 3. 上传 Stream 流，
 */
@interface HQLDemo3ViewController : UIViewController

@end

NS_ASSUME_NONNULL_END


/**
 
 # 使用 NSURLSession 上传文件主要步骤及注意点
 
 ## 主要步骤
 1. 确定上传请求的路径（ NSURL ）
 2. 创建可变的请求对象（ NSMutableURLRequest ）
 3. 修改请求方法为 POST
 4. 设置请求头信息（告知服务器端这是一个文件上传请求）
 5. 按照固定的格式拼接要上传的文件等参数
 6. 根据请求对象创建会话对象（ NSURLSession 对象）
 7. 根据 session 对象来创建一个 uploadTask 上传请求任务
 8. 执行该上传请求任务（调用 resume 方法）
 9. 得到服务器返回的数据，解析数据（上传成功 | 上传失败）
 
 ## 注意点
 
 1. 创建可变的请求对象，因为需要修改请求方法为 POST，设置请求头信息
 2. 设置请求头这个步骤可能会被遗漏
 3. 要处理上传参数的时候，一定要按照固定的格式来进行拼接
 4. 需要采用合适的方法来获得上传文件的二进制数据类型（ MIMEType ）

 ## MIMEType 类型
 
 MIME (Multipurpose Internet Mail Extensions) 是描述消息内容类型的因特网标准。

 MIME 消息能包含文本、图像、音频、视频以及其他应用程序专用的数据。
 
 参考：[MIME 参考手册](https://www.w3school.com.cn/media/media_mimeref.asp)
 
 */
