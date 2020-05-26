//
//  RMIOLoginView.h
//  ReadMeLoginDemo
//
//  Created by Qilin Hu on 2018/1/18.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

// 登录按钮 Block 对象
typedef void(^RMIOLoginButtonClickedHandle)(NSString *username, NSString *password);

/**
 登录视图
 */
@interface RMIOLoginView : UIView

- (instancetype)initWithLoginButtonClickedHandle:(RMIOLoginButtonClickedHandle)buttonClickedBlock;

@end
