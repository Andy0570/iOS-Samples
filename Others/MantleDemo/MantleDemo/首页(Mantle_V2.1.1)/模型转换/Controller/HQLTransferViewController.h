//
//  HQLTransferViewController.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/7/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 框架对比：Mantle && YYModel
 
 测试内容：
 当 Model 中某些属性为空时，Model -> JSON 时，JSON 中是否会有该空字段
 
 场景：我需要写一个通用请求类，请求类中的字段并不是每一次 API 接口中都有值、或者用到。
 */
@interface HQLTransferViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
